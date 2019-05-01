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
        let searchType: AnyObserver<String>
        let chatItemClick: AnyObserver<Int>
    }
    
    struct Output {
        let chatListObservable: Observable<[ChatItemViewModel]>
        let errorsObservable: Observable<Error>
        let openDetailOvservable: Observable<Chat>
    }
    
    // MARK: - Public properties
    let output: Output
    let input: Input
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    
    
    private let openDetailSubject = PublishSubject<Chat>()
    private let chatListSubject = PublishSubject<[ChatItemViewModel]>()
    private let errorsSubject = PublishSubject<Error>()
    //Input
    private let chatItemClickSubject = PublishSubject<Int>()
    private let searchTypeSubject = PublishSubject<String>()

    //State
    private var items: [Chat] = []
    
    private let disposeBag = DisposeBag()
    private let KEYWORD_DEBOUNCE = 0.3
    
    init(_ repo: ChatRepository, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        
        output = Output(chatListObservable: chatListSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable(),
                        openDetailOvservable: openDetailSubject.asObservable())
        
        
        input = Input(searchType: searchTypeSubject.asObserver(), chatItemClick: chatItemClickSubject.asObserver())
        
        chatItemClickSubject
            .map {
               self.items[$0]
            }
            .subscribe(onNext: { (selectedItem: Chat) in
                self.openDetailSubject.onNext(selectedItem)
            }, onError: {(error: Error) in
                self.errorsSubject.onNext(error)

            })
            .disposed(by: disposeBag)
        
        searchTypeSubject
            .debounce(KEYWORD_DEBOUNCE, scheduler: MainScheduler.instance)
            .flatMapLatest({ (keyword: String) -> Single<[Chat]> in
                if keyword.isEmpty {
                    return Single.just(self.items)
                }
                return repo.search(keyword: keyword)
            })
            .map { (items: [Chat]) in
                return self.toChatItemViewModel(chats: items)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onNext: { (items:[ChatItemViewModel]) in
                self.chatListSubject.onNext(items)
            }, onError: { (error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)

    }
    
    
    func getChatList() {
        
        repo.getChatList()
            .do(onSuccess: { (chats: [Chat]) in
                self.items = chats
            })
            .map { (items: [Chat]) in
                return self.toChatItemViewModel(chats: items)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onSuccess: { (items : [ChatItemViewModel]) in
                self.chatListSubject.onNext(items)
            },onError: {(error: Error) in
                self.errorsSubject.onNext(error)
            })
            .disposed(by: disposeBag)

        
    }
    
    
    private func toChatItemViewModel(chats: [Chat]) -> [ChatItemViewModel] {
        return chats.map({ (chat: Chat) -> ChatItemViewModel in
            ChatItemViewModel(id: chat.id, msgPreview: chat.msgPreview, userName: chat.userName, thumbnail: chat.thumbnail)
        })
        
    }
    
}
