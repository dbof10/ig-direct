//
//  MessageAdapter.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Cocoa
import IGListKit

class MessageAdapter:  NSObject, NSTableViewDataSource, NSTableViewDelegate  {

    private var items: [BaseMessageViewModel] = []
    private let TYPE_UNKNOWN = -1
    private let TYPE_INCOMING_TEXT = 1
    private let TYPE_OUTGOING_TEXT = 2
    private let TYPE_INCOMING_IMAGE = 3
    private let TYPE_OUTGOING_IMAGE = 4
    private let TYPE_INCOMING_LIKE = 5
    private let TYPE_OUTGOING_LIKE = 6
    private let TYPE_INCOMING_LINK = 7
    private let TYPE_OUTGOING_LINK = 8

    private let TYPE_INCOMING_UNSUPPORT = 19
    private let TYPE_OUTGOING_UNSUPPORT = 20
    private let tableView: NSTableView
    private let scrollView: NSScrollView

    var delegate: ScrollViewDelegate?
    
    init(_ tableView: NSTableView) {
        self.tableView = tableView
        self.scrollView = self.tableView.enclosingScrollView!

        super.init()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NSNib.init(nibNamed: "IncomingTextCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "IncomingTextCell"))
        tableView.register(NSNib.init(nibNamed: "OutgoingTextCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "OutgoingTextCell"))
        tableView.register(NSNib.init(nibNamed: "IncomingImageCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingImageCell"))
        tableView.register(NSNib.init(nibNamed: "OutgoingImageCell", bundle: nil), forIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutgoingImageCell"))
        tableView.register(NSNib.init(nibNamed: "IncomingLikeCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "IncomingLikeCell"))
        tableView.register(NSNib.init(nibNamed: "OutgoingLikeCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "OutgoingLikeCell"))
        tableView.register(NSNib.init(nibNamed: "IncomingLinkCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "IncomingLinkCell"))
        tableView.register(NSNib.init(nibNamed: "OutgoingLinkCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "OutgoingLinkCell"))
        tableView.register(NSNib.init(nibNamed: "IncomingUnsupportCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "IncomingUnsupportCell"))
        tableView.register(NSNib.init(nibNamed: "OutgoingUnsupportCell", bundle: nil), forIdentifier:
            NSUserInterfaceItemIdentifier(rawValue: "OutgoingUnsupportCell"))
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(scrollViewDidScroll),
            name:NSScrollView.didLiveScrollNotification,
            object: scrollView
        )
    }
    
    @objc func scrollViewDidScroll (notification: NSNotification) {

        guard let documentView = scrollView.documentView else { return }
        
        let clipView = scrollView.contentView
        if clipView.bounds.origin.y == 0 {
            delegate?.onScrollBeginTopReached()
        } else if clipView.bounds.origin.y + clipView.bounds.height == documentView.bounds.height {
            delegate?.onScrollBottomReached()            
        }
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
        case let vm as TextMessageViewModel:
            if vm.direction == .incoming {
                return self.TYPE_INCOMING_TEXT
            } else {
                return self.TYPE_OUTGOING_TEXT
            }
        case let vm as ImageMessageViewModel:
            if vm.direction == .incoming {
                return self.TYPE_INCOMING_IMAGE
            } else {
                return self.TYPE_OUTGOING_IMAGE
            }
        case let vm as LikeMessageViewModel:
            if vm.direction == .incoming {
                return self.TYPE_INCOMING_LIKE
            } else {
                return self.TYPE_OUTGOING_LIKE
            }
        case let vm as LinkMessageViewModel:
            if vm.direction == .incoming {
                return self.TYPE_INCOMING_LINK
            } else {
                return self.TYPE_OUTGOING_LINK
            }
        case let vm as UnsupportMessageViewModel:
            if vm.direction == .incoming {
                return self.TYPE_INCOMING_UNSUPPORT
            } else {
                return self.TYPE_OUTGOING_UNSUPPORT
            }
        default:
            return self.TYPE_UNKNOWN
        }
    }
    
    private func createView(_ parent: NSTableView, _ type: Int) -> NSView {
        switch type {
        case self.TYPE_INCOMING_TEXT:
          return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingTextCell"), owner: self) as! IncomingTextCellView
        case self.TYPE_OUTGOING_TEXT:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutgoingTextCell"), owner: self) as! OutgoingTextCellView
        case self.TYPE_INCOMING_IMAGE:
             return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingImageCell"), owner: self) as! IncomingImageCellView
        case self.TYPE_OUTGOING_IMAGE:
             return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutgoingImageCell"), owner: self) as! OutgoingImageCellView
        case self.TYPE_INCOMING_LIKE:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingLikeCell"), owner: self) as! IncomingLikeCellView
        case self.TYPE_OUTGOING_LIKE:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutgoingLikeCell"), owner: self) as! OutgoingLikeCellView
        case self.TYPE_INCOMING_LINK:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingLinkCell"), owner: self) as! IncomingLinkCellView
        case self.TYPE_OUTGOING_LINK:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutgoingLinkCell"), owner: self) as! OutgoingLinkCellView
        case self.TYPE_INCOMING_UNSUPPORT:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "IncomingUnsupportCell"), owner: self) as! IncomingUnsupportCellView
        case self.TYPE_OUTGOING_UNSUPPORT:
            return parent.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "OutgoingUnsupportCell"), owner: self) as! OutgoingUnsupportCellView
        default:
            fatalError("Unsupport view type \(type)")
        }
    }
    
    private func bindView(_ view: NSView, _ row: Int) {
        switch view {
        case let v as IncomingTextCellView:
            v.bind(viewModel: items[row] as! TextMessageViewModel)
            break
        case let v as OutgoingTextCellView:
            v.bind(viewModel: items[row] as! TextMessageViewModel)
            break
        case let v as IncomingImageCellView:
            v.bind(viewModel: items[row] as! ImageMessageViewModel)
            break
        case let v as OutgoingImageCellView:
            v.bind(viewModel: items[row] as! ImageMessageViewModel)
            break
        case let v as IncomingLinkCellView:
            v.bind(viewModel: items[row] as! LinkMessageViewModel)
            break
        case let v as OutgoingLinkCellView:
            v.bind(viewModel: items[row] as! LinkMessageViewModel)
            break
        default: ()
        }
    }
    
    func submitList(dataSource: [BaseMessageViewModel], completion: ((Bool) -> Void)? = nil){
        
        let oldItems = self.items
        let newItems = dataSource
        
        self.items = dataSource
        
        let diff = ListDiff(oldArray: oldItems, newArray: newItems, option: .equality)
        let batchUpdates = diff.forBatchUpdates()
        
        self.tableView.notifyDataSetChange(diffResult: batchUpdates, completion: completion)
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
}

protocol ScrollViewDelegate {
    
    func onScrollBottomReached()
    
    func onScrollBeginTopReached()
}
