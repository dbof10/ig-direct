//
//  ChatListviewController.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class ChatListViewController: NSViewController {
    
    var viewModel: ChatListViewModel!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tvChatList: NSTableView!
    private var chatListAdapter: ChatListAdapter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTableView()
        viewModel.getChatList()
    }
    
    private func setupTableView() {
        chatListAdapter = ChatListAdapter(tableView: self.tvChatList)
    }
    
    
    private func setupBinding() {
        viewModel
        .output
        .chatListObservable
            .subscribe(onNext: { [unowned self] (items: [ChatItemViewModel]) in
                self.chatListAdapter.submitList(dataSource: items)
                self.tvChatList.reloadData()
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
    
    
}
