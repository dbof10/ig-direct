//
//  ThreadScheduler.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/14/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation


import RxSwift

protocol ThreadScheduler {
    var ui: SchedulerType { get }
    var asyncUi: SchedulerType { get }
    var worker: SchedulerType { get }
}

struct WorkerThreadScheduler : ThreadScheduler {
    var ui: SchedulerType = MainScheduler.instance
    var asyncUi: SchedulerType = MainScheduler.asyncInstance
    var worker: SchedulerType = SerialDispatchQueueScheduler(qos: .background)
}
