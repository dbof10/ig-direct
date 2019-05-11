//
//  ChatDetailViewController.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class ChatDetailViewController: NSViewController, ScrollViewDelegate {
    
    @IBOutlet weak var tvMessages: NSTableView!

    @IBOutlet weak var etContent: NSTextField!
    var viewModel: ChatDetailViewModel!
    
    private var messagesAdapter: MessageAdapter!
    private let disposeBag = DisposeBag()
    
    //Input
    private let loadMoreSubject = PublishSubject<Any>()
    private let selectedChatSubject = PublishSubject<String>()
    private let enterTapSubject = PublishSubject<String>()

    private var requestScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesAdapter = MessageAdapter(tvMessages)
        messagesAdapter.delegate = self
        etContent.delegate = self
        setupBinding()
        tvMessages.intercellSpacing = NSSize(width: 0, height: 8)
    }
    
    private func setupBinding() {
        
      let selectedChatStream = selectedChatSubject
        .filter {
            !$0.isEmpty
        }
        .do(onNext: { _ in
            self.requestScroll = true
            self.messagesAdapter.submitList(dataSource: [])
        })
       
        
        let enterTapStream = enterTapSubject
            .do(onNext: { (String) in
                self.etContent.stringValue = ""
            })

        viewModel.bind(input: ChatDetailViewModel.Input(chatItemClick: selectedChatStream,
                                                        enterTap: enterTapStream,
                                                        loadMore: loadMoreSubject))
        viewModel
            .output
            .messagesObservable
            .subscribe(onNext: { [unowned self] (items: [BaseMessageViewModel]) in
                self.onNewList(items)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .errorsObservable
            .subscribe(onNext: { [unowned self] (error) in
                self.presentError(error)
            })
            .disposed(by: disposeBag)
        
    }
    
    func onNewList(_ items: [BaseMessageViewModel] ) {
        self.messagesAdapter.submitList(dataSource: items, completion: { (success) in
            if self.requestScroll {
                self.tvMessages.scrollTo(row: items.count - 1)
                self.requestScroll = false
            }
        })
    }
    
    func chatSelected(item: Chat) {
        selectedChatSubject.onNext(item.id)
    }
    
    func onScrollBottomReached() {
        
    }
    
    func onScrollBeginTopReached() {
       loadMoreSubject.onNext(true)
    }

}

extension ChatDetailViewController: NSTextFieldDelegate {
    

    override func keyUp(with event: NSEvent) {
        if event.keyCode == KeyCode.enterKey.rawValue {
            enterTapSubject.onNext(etContent.stringValue)
        }
    }
}
