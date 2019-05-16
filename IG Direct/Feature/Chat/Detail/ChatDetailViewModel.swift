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
        let chatItemClick: Observable<String>
        let enterTap: Observable<String>
        let loadMore: Observable<Any>
    }
    
    struct Output {
        let messagesObservable: Observable<[BaseMessageViewModel]>
        let errorsObservable: Observable<Error>
    }
    
    // MARK: - Public properties
    let output: Output
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    private let messageMapper: MessageViewModelMapper
    
    //Ouput
    private let messagesSubject = PublishSubject<[BaseMessageViewModel]>()
    private let errorsSubject = PublishSubject<Error>()
    
    
    //State
    private var items: [BaseMessageViewModel] = []
    private var selectedChatId = ""
    private var onEndReached = false
    private let disposeBag = DisposeBag()
    
    init(_ repo: ChatRepository,_ messageMapper: MessageViewModelMapper, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        self.messageMapper = messageMapper
        output = Output(messagesObservable: messagesSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
        
    }
    
    func bind(input: Input) {
        
        input.chatItemClick
            .filter {
                !$0.isEmpty
            }
            .do(onNext: {
                self.selectedChatId = $0
                self.onEndReached = false
            })
            .flatMapLatest {
                return self.repo.getChatDetail(id: $0)
                    .map {
                        return self.messageMapper.toViewModel(messages: $0)
                }
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (messages: [BaseMessageViewModel]) in
                self.items = messages
                self.messagesSubject.onNext(messages)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
                
            })
            .disposed(by: disposeBag)
        
        input.enterTap
            .filter {
                !$0.isEmpty && !self.selectedChatId.isEmpty
            }
            .do(onNext: { _ in
                self.onEndReached = false
            })
            .flatMapLatest {
                return self.repo.sendMessage(id: self.selectedChatId, content: $0)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (messages: SendMessageResponse) in
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
                
            })
            .disposed(by: disposeBag)
        
        input.loadMore
            .filter { _ in
                self.onEndReached == false
            }
            .flatMapLatest { _ in
                return self.repo.getOlderChatDetail(id: self.selectedChatId)
                    .map {
                        return self.messageMapper.toViewModel(messages: $0)
                }
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (messages: [BaseMessageViewModel]) in
                if messages.isEmpty {
                    self.onEndReached = true
                }
                self.items = messages + self.items
                self.messagesSubject.onNext(self.items)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
                
            })
            .disposed(by: disposeBag)
    }


}
