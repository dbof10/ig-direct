//
//  ChatListViewController.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import RxSwift

class ChatListViewController: NSViewController {
    
    var viewModel: ChatListViewModel!
    
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var tvSearch: NSTextField!
    @IBOutlet weak var tvChatList: NSTableView!
    private var chatListAdapter: ChatListAdapter!
    private var itemClick = PublishSubject<Int>()
    private var reloadSubject = PublishSubject<Any>()
    private var requestSelectedRow = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBinding()
        setupTableView()
        viewModel.getChatList()
    }
    
    private func setupTableView() {
        chatListAdapter = ChatListAdapter(tableView: self.tvChatList)
        chatListAdapter.clickDelegate = self
    }
    
    
    private func setupBinding() {
        
        viewModel.bind(input: ChatListViewModel.Input(
            reload: reloadSubject,
            searchType:  tvSearch.rx.text.orEmpty.asObservable(),
            chatItemClick:  itemClick))
        
        viewModel
            .output
            .chatListObservable
            .subscribe(onNext: { [unowned self] (items: [ChatListItemViewModel]) in
                self.submitList(items)
            })
            .disposed(by: disposeBag)
        
        viewModel
            .output
            .errorsObservable
            .subscribe(onNext: { [unowned self] (error) in
                self.presentError(error)
            })
            .disposed(by: disposeBag)
        
        viewModel.output
            .openDetailOvservable
            .subscribe(onNext: { [unowned self] (item: ChatListItemViewModel) in
               self.openChatDetail(item)
            })
            .disposed(by: disposeBag)
        
        viewModel.output
            .selectRowObservable
            .subscribe(onNext: { [unowned self] (selectedRow: Int) in
                self.requestSelectedRow = selectedRow
            })
            .disposed(by: disposeBag)
    }
    
    private func submitList(_ items : [ChatListItemViewModel]) {
       self.chatListAdapter.submitList(dataSource: items, completion: { (success) in
        if self.requestSelectedRow != -1 {
            self.tvChatList.selectRow(at: 0)
        }
        self.requestSelectedRow = -1
        })
    }
    
    func reload () {
        reloadSubject.onNext(true)
    }
    
    private func openChatDetail(_ item: ChatListItemViewModel) {
        guard let splitVC = parent as? NSSplitViewController else { return }
        
        if let detail = splitVC.children[1] as? ChatDetailViewController {
            detail.chatSelected(item: item)
        }
    }
}

extension ChatListViewController: ChatItemClickDelegate {
    
    func onItemClicked(position: Int) {
        itemClick.onNext(position)
    }

}
