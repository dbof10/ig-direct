//
//  ChatListAdapter.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import IGListKit

class ChatListAdapter: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    private var items: [ChatListItemViewModel] = []
    private let tableView: NSTableView
    var clickDelegate: ChatItemClickDelegate? = nil
    
    init(tableView: NSTableView) {
        self.tableView = tableView
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let chatView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "ChatItemCellView"), owner: self) as! ChatItemCellView
        chatView.bind(viewModel: items[row])
        return chatView
    }
    
    func submitList(dataSource: [ChatListItemViewModel], completion: ((Bool) -> Void)? = nil) {
    
        let oldItems = self.items
        let newItems = dataSource
        
        self.items = dataSource
        
        let diff = ListDiff(oldArray: oldItems, newArray: newItems, option: .equality).forBatchUpdates()
        
        self.tableView.notifyDataSetChange(diffResult: diff, completion: completion)
    
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow != -1 else { return }
        clickDelegate?.onItemClicked(position: tableView.selectedRow)

    }
    
}

protocol ChatItemClickDelegate : class {
    func onItemClicked(position: Int)
}
