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

class ChatDetailViewController: NSViewController {
    
    @IBOutlet weak var tvMessages: NSTableView!

    @IBOutlet weak var etContent: NSTextField!
    var viewModel: ChatDetailViewModel!
    
    private var messagesAdapter: MessageAdapter!
    private let disposeBag = DisposeBag()
    
    //Input
    private let selectedChat = PublishSubject<String>()
    private let enterTap = PublishSubject<String>()

    override func viewDidLoad() {
        super.viewDidLoad()
        messagesAdapter = MessageAdapter(tvMessages)
        
        etContent.delegate = self
        setupBinding()
        tvMessages.intercellSpacing = NSSize(width: 0, height: 8)
    }
    
    private func setupBinding() {
      selectedChat
        .subscribe(viewModel.input.chatItemClick)
        .disposed(by: disposeBag)
        
        enterTap
            .do(onNext: { (String) in
                self.etContent.stringValue = ""
            })
        .subscribe(viewModel.input.enterTap)
            .disposed(by: disposeBag)

        viewModel
            .output
            .messagesObservable
            .subscribe(onNext: { [unowned self] (items: [BaseMessageViewModel]) in
                self.messagesAdapter.submitList(dataSource: items)
                self.tvMessages.reloadData()
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
    
    func chatSelected(item: Chat) {
        selectedChat.onNext(item.id)
    }
}

extension ChatDetailViewController: NSTextFieldDelegate {
    

    override func keyUp(with event: NSEvent) {
        if event.keyCode == KeyCode.enterKey.rawValue {
            enterTap.onNext(etContent.stringValue)
        }
    }
}
