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
import Quartz
class ChatDetailViewController: NSViewController, ScrollViewDelegate {
    
    @IBOutlet weak var tvMessages: NSTableView!
    @IBOutlet weak var etContent: NSTextField!
    @IBOutlet weak var ivPhoto: NSButton!
    
    var viewModel: ChatDetailViewModel!
    
    @IBOutlet weak var ivEmoji: NSButton!
    private var messagesAdapter: MessageAdapter!
    private let disposeBag = DisposeBag()
    
    //Input
    private let loadMoreSubject = PublishSubject<Any>()
    private let selectedChatSubject = PublishSubject<ChatListItemViewModel>()
    private let enterTapSubject = PublishSubject<String>()
    private let photoSelectSubject = PublishSubject<String>()
    private var requestScroll = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesAdapter = MessageAdapter(tvMessages)
        messagesAdapter.delegate = self
        etContent.delegate = self
        setupBinding()
        setupListener()
        tvMessages.intercellSpacing = NSSize(width: 0, height: 8)
    }
    
    private func setupListener() {
        
    }
    
    private func setupBinding() {
        
      let selectedChatStream = selectedChatSubject
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
                                                        photoSelect: photoSelectSubject,
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
        
        viewModel
        .output
        .reloadObservable
            .subscribe(onNext: { _ in
                self.reloadChatList()
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
    
    func chatSelected(item: ChatListItemViewModel) {
        selectedChatSubject.onNext(item)
    }
    
    func onScrollBottomReached() {
        
    }
    
    func onScrollBeginTopReached() {
       loadMoreSubject.onNext(true)
    }
    
    @IBAction
    func onEmojiClick(_ sender: Any) {
        etContent!.window!.makeFirstResponder(etContent)
        NSApp.orderFrontCharacterPalette(self.etContent)
        self.etContent.currentEditor()!.moveToEndOfLine(nil) //multi emojis

    }
    
    @IBAction
    func onPhotoClicked(_ sender: Any) {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = false
        openPanel.canCreateDirectories = false
        openPanel.canChooseFiles = true
        openPanel.allowedFileTypes = ["jpg"]
        
        openPanel.beginSheetModal(for: self.view.window!) { (result) in
            if result == NSApplication.ModalResponse.OK {
                self.photoSelectSubject.onNext(openPanel.url!.path)
            }

        }
    }
    
    private func reloadChatList() {

        guard let splitVC = parent as? NSSplitViewController else { return }
        if let list = splitVC.children[0] as? ChatListViewController {
            list.reload()
        }
    }
}

extension ChatDetailViewController: NSTextFieldDelegate {
    
    override func keyUp(with event: NSEvent) {
        if event.keyCode == KeyCode.enterKey.rawValue {
            enterTapSubject.onNext(etContent.stringValue)
        }
    }
}
