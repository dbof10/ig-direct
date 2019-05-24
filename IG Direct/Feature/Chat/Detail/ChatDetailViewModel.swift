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
        let chatItemClick: Observable<ChatListItemViewModel>
        let enterTap: Observable<String>
        let loadMore: Observable<Any>
    }
    
    struct Output {
        let reloadObservable: Observable<Any>
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
    private let reloadChatListSubject = PublishSubject<Any>()
    private let reloadChatSubject = PublishSubject<Any>()
    
    //State
    private var items: [BaseMessageViewModel] = []
    private var selectedChatViewModel: ChatListItemViewModel? = nil
    private var onEndReached = false
    private let disposeBag = DisposeBag()
    private var refreshChatDisposable: Disposable? = nil

    
    init(_ repo: ChatRepository,_ messageMapper: MessageViewModelMapper, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        self.messageMapper = messageMapper
        
        output = Output(
            reloadObservable: reloadChatListSubject.asObservable(),
            messagesObservable: messagesSubject.asObservable(),
            errorsObservable: errorsSubject.asObservable())
        
    }
    
    func bind(input: Input) {
        
       let clickStream = input.chatItemClick
            .do(onNext: {
                self.selectedChatViewModel = $0
                self.onEndReached = false
            })
            .filter {
                !$0.id.isEmpty
            }
            .share()
        
        
        clickStream
                .observeOn(threadScheduler.asyncUi)
                .subscribe( { _ in
                self.refreshChatDisposable?.dispose()
                    if !self.selectedChatViewModel!.newChat {
                        self.refreshChat()
                    }
            })
            .disposed(by: disposeBag)

    
        
        clickStream
            .filter {
                 !$0.newChat
            }
            .flatMapLatest {
                return self.repo.getChatDetail(id: $0.id)
                    .map {
                        return self.messageMapper.toViewModel(messages: $0)
                }
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (messages: [BaseMessageViewModel]) in
                self.updateCurrentList(messages)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        reloadChatSubject
            .flatMapLatest {_ in
                return self.repo.getChatDetail(id: self.selectedChatViewModel!.id)
                    .map {
                        return self.messageMapper.toViewModel(messages: $0)
                }
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (messages: [BaseMessageViewModel]) in
               self.updateCurrentList(messages)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        
        input.enterTap
            .filter {
                !$0.isEmpty && self.selectedChatViewModel?.id.isEmpty == false
                && self.selectedChatViewModel?.newChat == false
            }
            .do(onNext: { _ in
                self.onEndReached = false
            })
            .flatMapLatest {
                return self.repo.sendMessage(id: self.selectedChatViewModel!.id, content: $0)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (messages: SendMessageResponse) in
                self.reloadChatSubject.onNext(true)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
                
            })
            .disposed(by: disposeBag)
        
        input.enterTap
            .filter {
                !$0.isEmpty && self.selectedChatViewModel?.id.isEmpty == false
                && self.selectedChatViewModel?.newChat == true
            }
            .flatMapLatest {
                return self.repo.createChat(userId: self.selectedChatViewModel!.id, message: $0)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (Bool) in
                self.reloadChatListSubject.onNext(true)
            }, onError: { (error: Error) in
                 self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        input.loadMore
            .filter { _ in
                self.onEndReached == false
            }
            .flatMapLatest { _ in
                return self.repo.getOlderChatDetail(id: self.selectedChatViewModel!.id)
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

    private func updateCurrentList(_ messages: [BaseMessageViewModel]) {
        self.items = messages
        self.messagesSubject.onNext(messages)
    }
    
    private func refreshChat() {

        refreshChatDisposable = Observable<Int>.interval(5.0, scheduler: threadScheduler.ui)
                                               .observeOn(threadScheduler.ui)
            .subscribe({_ in
                self.reloadChatSubject.onNext(true)
            })
    }

}
