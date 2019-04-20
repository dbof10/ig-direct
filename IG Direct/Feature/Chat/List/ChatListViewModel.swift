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
        
    }
    struct Output {
        let chatListObservable: Observable<[ChatItemViewModel]>
        let errorsObservable: Observable<Error>
    }
    
    // MARK: - Public properties
    let output: Output
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    private let disposeBag = DisposeBag()
    private let chatListSubject = PublishSubject<[ChatItemViewModel]>()
    private let errorsSubject = PublishSubject<Error>()
    
    init(_ repo: ChatRepository, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
        
        output = Output(chatListObservable: chatListSubject.asObservable(),
                        errorsObservable: errorsSubject.asObservable())
        
    }
    
    
    func getChatList() {
        
        repo.getChatList()
            .map { (items: [Chat]) in
                return self.toChatItemViewModel(chats: items)
            }
            .subscribeOn(threadScheduler.worker)
            .observeOn(threadScheduler.ui)
            .subscribe(onSuccess: { (items : [ChatItemViewModel]) in
                self.chatListSubject.onNext(items)
            },onError: {(error: Error) in
                print("xxxxx \(error)")
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
