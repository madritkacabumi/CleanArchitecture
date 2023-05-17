//
//  Publisher+Extensions.swift
//  CleanArchitectureExamples
//
//  Created by Madrit Kacabumi on 4.5.23.
//

import Combine

extension Publisher {
    
    public func sink() -> AnyCancellable {
        return self.sink(receiveCompletion: { _ in }, receiveValue: { _ in })
    }
    
    func handleValue(callback: @escaping ( _ data: Output) -> Void) -> Publishers.HandleEvents<Self> {
        return self.handleEvents(receiveOutput: { output in
            callback(output)
        })
    }
    
    func handleError(callback: @escaping ( _ error: Failure) -> Void) -> Publishers.HandleEvents<Self> {
        return self.handleEvents(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                callback(error)
            }
        })
    }
}

