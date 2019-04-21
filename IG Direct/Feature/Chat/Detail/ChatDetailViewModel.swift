//
//  ChatDetailViewModel.swift
//  IG Direct
//
//  Created by Daniel Lee on 4/21/19.
//  Copyright © 2019 Ctech. All rights reserved.
//

import Foundation
import RxSwift

class ChatDetailViewModel: BaseViewModel {
 
    struct Input {
    }
    
    struct Output {
    }
    
    // MARK: - Public properties
  //  let output: Output
 //   let input: Input
    
    private let repo: ChatRepository
    private let threadScheduler: ThreadScheduler
    
    private let disposeBag = DisposeBag()
    
    
    init(_ repo: ChatRepository, _ threadScheduler: ThreadScheduler) {
        self.repo = repo
        self.threadScheduler = threadScheduler
    }
    
    
    func onItemSelected(_ item : ChatItemViewModel)  {
        
    }
}
