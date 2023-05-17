//
//  XCTestCase+Extensions.swift
//  CleanArchitectureExamplesTests
//
//  Created by Madrit Kacabumi on 6.5.23.
//

import XCTest
import Combine

import Combine
import XCTest

extension XCTestCase {
    
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        expectValue: Bool = false,
        file: StaticString = #file,
        line: UInt = #line,
        trigger: (() -> Void)? = nil
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")
        
        var fullfilled: Bool = false
        
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        result = .failure(error)
                    case .finished:
                        if expectValue && result == nil {
                            break
                        }
                        break
                }
                if !fullfilled {
                    if (expectValue && result != nil || !expectValue) {
                        expectation.fulfill()
                        fullfilled = true
                    }
                }
            },
            receiveValue: { value in
                result = .success(value)
                if !fullfilled {
                    expectation.fulfill()
                    fullfilled = true
                }
            }
        )
        
        trigger?()
        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return try unwrappedResult.get()
    }
    
    func triggeredPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        expectValue: Bool = false,
        file: StaticString = #file,
        line: UInt = #line,
        trigger: (() -> Void)? = nil
    ) throws -> Bool {
        let expectation = self.expectation(description: "Triggering publisher")
        var fullfilled: Bool = false
        var triggered = false
        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case .failure(let error):
                        triggered = true
                    case .finished:
                        break
                }
                triggered = true
                if !fullfilled {
                    expectation.fulfill()
                    fullfilled = true
                }
            },
            receiveValue: { value in
                
                if !fullfilled {
                    triggered = true
                    expectation.fulfill()
                    fullfilled = true
                }
            }
        )
        trigger?()
        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()
        
        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            triggered,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )
        
        return unwrappedResult
    }
}
