//
//  ChatListAdapter.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class ChatListAdapter: NSObject, NSTableViewDataSource, NSTableViewDelegate {
    
    private var items: [ChatItemViewModel] = []
    
    init(tableView: NSTableView) {
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let chatView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "defaultRow"), owner: self) as! ChatItemCellView
        chatView.bind(viewModel: items[row])
        return chatView
    }
    
    func submitList(dataSource: [ChatItemViewModel]){
        self.items = dataSource
    }
}
