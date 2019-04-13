//
//  AppLogic.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/13/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import RxSwift

protocol AppLogic {
    func execute() -> Completable
}
