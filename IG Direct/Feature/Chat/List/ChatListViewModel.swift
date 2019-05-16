//
//  ChatListViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import RxSwift

class ChatListViewModel: BaseViewModel {
    
    struct Input {
        let searchType: Observable<String>
        let chatItemClick: Observable<Int>
    }
    
    struct Output {
        let chatListObservable: Observable<[ChatListItemViewModel]>
        let errorsObservable: Observable<Error>
        let openDetailOvservable: Observable<ChatListItemViewModel>
    }
    
    // MARK: - Public properties
    let output: Output
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    
    
    private let openDetailSubject = PublishSubject<ChatListItemViewModel>()
    private let chatListSubject = PublishSubject<[ChatListItemViewModel]>()
    private let errorsSubject = PublishSubject<Error>()
    
    //State
    private var cacheItems: [ChatListItemViewModel] = []
    private var items: [ChatListItemViewModel] = []
    
    private let disposeBag = DisposeBag()
    private let KEYWORD_DEBOUNCE = 0.3
    
    init(_ repo: ChatRepository, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        
        output = Output(chatListObservable: chatListSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable(),
                        openDetailOvservable: openDetailSubject.asObservable())
    }
    
    
    func bind(input: Input) {
        
        input.chatItemClick
            .map {
                self.items[$0]
            }
            .subscribe(onNext: { (selectedItem: ChatListItemViewModel) in
                self.openDetailSubject.onNext(selectedItem)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
        
        input.searchType
            .debounce(KEYWORD_DEBOUNCE, scheduler: MainScheduler.instance)
            .flatMapLatest({ (keyword: String) -> Single<[ChatListItemViewModel]> in
                if keyword.isEmpty {
                    return Single.just(self.cacheItems)
                }
                return self.repo.search(keyword: keyword).map {
                    self.toChatItemViewModel(users: $0)
                }
            })
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (items:[ChatListItemViewModel]) in
                self.items = items
                self.chatListSubject.onNext(items)
            }, onError: { (error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)
    }
    
    
    func getChatList() {
        
        repo.getChatList()
            .map { (items: [Chat]) in
                return self.toChatItemViewModel(chats: items)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onSuccess: { (items : [ChatListItemViewModel]) in
                self.cacheItems = items
                self.items = items
                self.chatListSubject.onNext(items)
            },onError: {(error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)

    }
    
    
    private func toChatItemViewModel(chats: [Chat]) -> [ChatListItemViewModel] {
        return chats.map({ (chat: Chat) -> ChatItemViewModel in
            ChatItemViewModel(id: chat.id, msgPreview: chat.msgPreview, account: chat.account)
        })
        
    }
    
    private func toChatItemViewModel(users: [User]) -> [ChatListItemViewModel] {
        return users.map({ (user: User) -> UserItemViewModel in
            UserItemViewModel(user: user)
        })
        
    }
    
}
