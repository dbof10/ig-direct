//
//  ChatRepository.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/19/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import RxSwift
class ChatRepository {
    
    private let apiClient: IGApiClient
    
    init(_ apiClient: IGApiClient) {
        self.apiClient = apiClient
    }
    
    
    func getChatList() -> Observable<[Chat]> {
        return apiClient.chatList()
                .asObservable()
                .smartRetry(delay: DelayOptions.constant(time: 5))
    }
    
    func getChatDetail(id: String) ->Single<[Message]> {
        return apiClient.chatDetail(id: id)
    }
    
    func createChat(userId: String, message: String) -> Single<Bool> {
        return apiClient.createChat(userId , message)
                        .catchErrorJustReturn(false)

    }
    
    func getOlderChatDetail(id: String) -> Single<[Message]> {
        return apiClient.chatOlderDetail(id: id)
        
    }
    
    func sendMessage(id:String, content: String) -> Single<SendMessageResponse> {
        return apiClient.send(id: id, content: content)
    }
    
    func search(keyword: String) -> Single<[User]> {
        return apiClient.search(keyword: keyword)
    }
    
    func uploadPhoto(userId: Int, imagePath: String) -> Single<Bool> {
        return apiClient.uploadPhoto(userId, imagePath)
                        .catchErrorJustReturn(false)
    }
}
