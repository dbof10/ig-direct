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
        let chatItemClick: AnyObserver<Int>
    }
    
    struct Output {
        let chatListObservable: Observable<[ChatItemViewModel]>
        let errorsObservable: Observable<Error>
        let openDetailOvservable: Observable<ChatItemViewModel>
    }
    
    // MARK: - Public properties
    let output: Output
    let input: Input
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    
    
    private let openDetailSubject = PublishSubject<ChatItemViewModel>()
    private let chatListSubject = PublishSubject<[ChatItemViewModel]>()
    private let errorsSubject = PublishSubject<Error>()
    //Input
    private let chatItemClickSubject = PublishSubject<Int>()

    //State
    private var items: [ChatItemViewModel] = []
    
    private let disposeBag = DisposeBag()

    
    init(_ repo: ChatRepository, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        
        output = Output(chatListObservable: chatListSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable(),
                        openDetailOvservable: openDetailSubject.asObservable())
        
        
        input = Input(chatItemClick: chatItemClickSubject.asObserver())
        
        chatItemClickSubject
            .map {
               self.items[$0]
            }
            .subscribe(onNext: { (selectedItem: ChatItemViewModel) in
                self.openDetailSubject.onNext(selectedItem)
            }, onError: {(error: Error) in
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
            .subscribe(onSuccess: { (items : [ChatItemViewModel]) in
                self.items = items
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
