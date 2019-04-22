//
//  MessageAdapter.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa

class MessageAdapter:  NSObject, NSTableViewDataSource, NSTableViewDelegate  {

    private var items: [BaseMessageViewModel] = []
    private let TYPE_UNKNOWN = 1
    private let TYPE_INCOMING_TEXT = 1

    init(_ tableView: NSTableView) {
        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NSNib.init(nibNamed: "IncomingTextCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingTextCell"))
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let type = getViewType(row)
        let view = createView(tableView, type)
        bindView(view, row)
        return view
    }
    
    
    
    private func getViewType(_ row: Int) -> Int {
        let message = items[row]
        switch message {
        case is TextMessageViewModel:
            return self.TYPE_INCOMING_TEXT
        default:
            return self.TYPE_UNKNOWN
        }
    }
    
    private func createView(_ parent: NSTableView, _ type: Int) -> NSView {
        switch type {
        case self.TYPE_INCOMING_TEXT:
          return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingTextCell"), owner: self) as! IncomingTextCellView
        default:
            fatalError("Unsupport view type \(type)")
        }
    }
    
    private func bindView(_ view: NSView, _ row: Int) {
        switch view {
        case let v as IncomingTextCellView:
            v.bind(viewModel: items[row] as! TextMessageViewModel)
            break
        default: ()
        }
    }
    
    func submitList(dataSource: [BaseMessageViewModel]){
        self.items = dataSource
    }
}
