//
//  Reachability.swift
//  IG Direct
//
//  Created by Daniel Lee on 5/24/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import RxCocoa


final class Reachability {
    static let shared = Reachability()
    
    private let reachability = NetworkReachabilityManager()
    
    var didBecomeReachable: Observable<Void> { return _didBecomeReachable.asObservable() }
    private let _didBecomeReachable = PublishSubject<Void>()
    
    init() {
        if let reachability = self.reachability {
            reachability.listener = { [weak self] in
                self?.update($0)
            }
            reachability.startListening()
        }
    }
    
    private func update(_ status: NetworkReachabilityManager.NetworkReachabilityStatus) {
        if case .reachable = status {
            _didBecomeReachable.onNext(())
        }
    }
}
