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

    var viewModel: ChatDetailViewModel!
    
    private var messagesAdapter: MessageAdapter!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesAdapter = MessageAdapter(tvMessages)
        setupBinding()
    }
    
    private func setupBinding() {
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
    
    func chatSelected(item: ChatItemViewModel) {
        viewModel.onItemSelected(item)
    }
}
