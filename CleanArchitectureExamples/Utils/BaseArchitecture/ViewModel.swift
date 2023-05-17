//
//  ViewModel.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine

public typealias Trigger<T> = PassthroughSubject<T, Never>
public typealias VoidTrigger = Trigger<Void>

extension Trigger {
    
    func fire(value: Output) {
        self.send(value)
    }
}

extension Trigger where Output == Void {
    
    func fire() {
        self.fire(value: ())
    }
}

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output
}
