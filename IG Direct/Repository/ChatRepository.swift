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
    
    
    func getChatList() -> Single<[Chat]> {
        return apiClient.chatList()
    }
    
    func getChatDetail(id: String) ->Single<[BaseMessage]>{
        return apiClient.chatDetail(id: id)
    }
    
    func sendMessage(id:String, content: String) -> Single<SendMessageResponse> {
        return apiClient.send(id: id, content: content)
    }
    
    func search(keyword: String) -> Single<[Chat]> {
        return apiClient.search(keyword: keyword)
    }
}
