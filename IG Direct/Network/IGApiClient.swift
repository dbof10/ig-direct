//
//  IGApiClient.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/7/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Moya

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
    
    private let client: MoyaProvider<Unsplash>
    
    
    init() {
        let endpointClosure = { (target: Unsplash) -> Endpoint in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint
                .adding(newHTTPHeaderFields:["Authorization":"Client-ID \(Unsplash.CLIENT_ID)"])
        }
        client = MoyaProvider<Unsplash>( endpointClosure: endpointClosure, plugins: [NetworkLoggerPlugin(verbose: true,
                                                                                                        cURL: false,
                                                                                                        responseDataFormatter: JSONResponseDataFormatter)]
        )
    }
}


public enum Unsplash {
    case photos(Int, Int, String)
    case photo(String)
}

extension Unsplash: TargetType {
    public var headers: [String : String]? {
        return nil
    }
    
    static let CLIENT_ID = "826ba9021d70257ea05a10cef8a36a41d35f54438f2b2093a4e842c955928c38"
    static let SECRET_KEY = "eb3c546b5c0dfc580321ff02c7e018c6007ac9f4cf56a070c5cffd6ad5329bc7"
    
    public var baseURL: URL {
        return URL(string: "https://api.unsplash.com")!
    }
    
    public var path: String {
        switch self {
        case .photos:
            return "photos"
        case .photo(let id):
            return "photos/\(id)"
        }
    }
    
    public var method: Moya.Method {
        return .get
    }
    
    public var task: Task {
        switch self {
        case .photo:
            return .requestPlain
        case let .photos(page, limit, order):
            return .requestParameters(parameters: ["page": page, "per_page": limit, "order_by": order], encoding: URLEncoding.queryString)
            
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .photos:
            return URLEncoding.queryString
        default:
            return URLEncoding.queryString
        }
    }
    
    public var sampleData: Data {
        return "".data(using: String.Encoding.utf8)!
    }
    
    public var validate: Bool {
        switch self {
        case .photos:
            return true
        default:
            return false
        }
    }
}

public func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
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
