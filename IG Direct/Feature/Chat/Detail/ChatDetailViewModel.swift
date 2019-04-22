//
//  ChatDetailViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import RxSwift

class ChatDetailViewModel: BaseViewModel {
 
    struct Input {
    }
    
    struct Output {
        let messagesObservable: Observable<[BaseMessageViewModel]>
        let errorsObservable: Observable<Error>
    }
    
    // MARK: - Public properties
    let output: Output
 //   let input: Input
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    private let messageMapper: MessageViewModelMapper
    
    private let messagesSubject = PublishSubject<[BaseMessageViewModel]>()
    private let errorsSubject = PublishSubject<Error>()

    
    //State
    private var items: [BaseMessageViewModel] = []
    
    private let disposeBag = DisposeBag()
    
    
    init(_ repo: ChatRepository,_ messageMapper: MessageViewModelMapper, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        self.messageMapper = messageMapper
        output = Output(messagesObservable: messagesSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
    }
    
    
    func onItemSelected(_ item : ChatItemViewModel)  {
        repo.getChatDetail(id: item.id)
            .map {
                return self.messageMapper.toViewModel(messages: $0)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onSuccess: { (messages: [BaseMessageViewModel]) in
                self.items = messages
                self.messagesSubject.onNext(messages)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
                
            })
            .disposed(by: disposeBag)
    }
}
