//
//  DisposeBag.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine

class DisposeBag {
    
    var subscriptions = Set<AnyCancellable>()
    
    func clear() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    
    func store(in disposeBag: DisposeBag) {
        disposeBag.subscriptions.insert(self)
    }
}

