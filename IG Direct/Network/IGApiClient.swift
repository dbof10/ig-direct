//
//  IGApiClient.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/7/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Moya_ObjectMapper

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data
    }
}


class IGApiClient {
    
    private let client: MoyaProvider<IgDirect>
    private let userSecret: UserSecretManager
    
    init(_ userSecret: UserSecretManager) {
        self.userSecret = userSecret
        let endpointClosure = { (target: IgDirect) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            let token = userSecret.getUserToken()
            return defaultEndpoint
            .adding(newHTTPHeaderFields:["x-session": token])
        }
        client = MoyaProvider<IgDirect>( endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true,
                                                                                                         cURL: false,
                                                                                                         responseDataFormatter: JSONResponseDataFormatter)]
        )
    }
    
    func login(credentials: Credentials) -> Single<LoginResponse> {
        return client.rx.request(.login(credentials.email, credentials.password))
            .filterSuccessfulStatusCodes()
            .mapObject(LoginResponse.self)
    }
    
    func chatList() -> Single<[Chat]> {
        return client.rx.request(.list)
         .filterSuccessfulStatusCodes()
        .mapArray(Chat.self)
    }
    
    func chatDetail(id:String) -> Single<[BaseMessage]> {
        return client.rx.request(.detail(id))
            .filterSuccessfulStatusCodes()
            .mapArray(BaseMessage.self)
    }
    
    func send(id:String, content: String) -> Single<SendMessageResponse> {
        return client.rx.request(.send(id, content))
                .filterSuccessfulStatusCodes()
                .mapObject(SendMessageResponse.self)
    }
}


public enum IgDirect {
    case login(String, String)
    case list
    case detail(String)
    case send(String, String)
}

extension IgDirect: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    

    public var baseURL: URL {
        return URL(string: "http://127.0.0.1:5000")!
    }
    
    public var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .list:
            return "/chats/all"
        case .detail(let id):
            return "/chats/\(id)"
        case .send(let id, _):
            return "/chats/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .list:
            return .get
        case .detail:
            return .get
        case .send:
            return .post
        }
    }
    
    public var task: Task {
        switch self {
        case .login(let email,let password):
            return .requestParameters(parameters: ["userName": email, "password": password], encoding: JSONEncoding.default)
        case .list:
            return .requestPlain
        case .detail:
            return .requestPlain
        case .send(_ , let content):
            return .requestParameters(parameters: ["message": content], encoding: JSONEncoding.default)
        }
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var validate: Bool {
        switch self {
        default:
            return false
        }
    }
    
    public func url(_ route: TargetType) -> String {
        return route.baseURL.appendingPathComponent(route.path).absoluteString
    }
}

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try self.mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}
