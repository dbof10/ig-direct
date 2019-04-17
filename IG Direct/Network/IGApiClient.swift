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
    
    
    init() {
        let endpointClosure = { (target: IgDirect) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint
            // .adding(newHTTPHeaderFields:["Authorization":"Client-ID \(Unsplash.CLIENT_ID)"])
        }
        client = MoyaProvider<IgDirect>( endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true,
                                                                                                         cURL: false,
                                                                                                         responseDataFormatter: JSONResponseDataFormatter)]
        )
    }
    
    func login(credentials: Credentials) -> Single<LoginResponse> {
        return client.rx.request(.login(credentials.email, credentials.password))
            .mapObject(LoginResponse.self)
    }
}


public enum IgDirect {
    case login(String, String)
    
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
            //        case .photo(let id):
            //            return "photos/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
            return .get
        }
    }
    
    public var task: Task {
        switch self {
            
        case .login(let email,let password):
            return .requestParameters(parameters: ["userName": email, "password": password], encoding: JSONEncoding.default)
            //  case let .photos(page, limit, order):
            //      return .requestParameters(parameters: ["page": page, "per_page": limit, "order_by": order], encoding: URLEncoding.queryString)
            
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var validate: Bool {
        switch self {
            //        case .photos:
        //            return true
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
