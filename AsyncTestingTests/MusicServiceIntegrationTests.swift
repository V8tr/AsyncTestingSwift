//
//  MusicServiceIntegrationTests.swift
//  AsyncTestingTests
//
//  Created by Vadym Bulavin on 3/2/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import XCTest
@testable import AsyncTesting

class MusicServiceIntegrationTests: XCTestCase {
    
    func sampleExpectation() {
        let exp = expectation(description: #function)
        
        DispatchQueue.global().async {
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 1)
        
        // Assert
    }
    
    func testSearch() {
        let didReceiveResponse = expectation(description: #function)
        
        let sut = MusicService(httpClient: RealHTTPClient())
        
        var result: Result<[Track], Error>?
        
        sut.search("ANYTHING") {
            result = $0
            didReceiveResponse.fulfill()
        }
        
        wait(for: [didReceiveResponse], timeout: 5)
        
        XCTAssertNotNil(result?.value)
    }
    
    func testSearchAuthorized() {
        let didReceiveNotification = expectation(forNotification: .sessionEnded, object: nil)
        didReceiveNotification.isInverted = true
        
        let sut = MusicService(httpClient: RealHTTPClient())
                
        sut.search("T1") { _ in }
        
        wait(for: [didReceiveNotification], timeout: 5)
    }
    
    func testSearchBusyAssert() {
        let sut = MusicService(httpClient: RealHTTPClient())
        
        var result: Result<[Track], Error>?
        
        sut.search("ANYTHING") { result = $0 }
        
        expectToEventually(result?.value != nil, timeout: 5)
    }
    
    func testExpectationFulfillmentCount() {
        let exp = expectation(description: #function)
        exp.expectedFulfillmentCount = 3
        
    //        sut.doSomethingThreeTimes()
        
        wait(for: [exp], timeout: 1)
    }

    func testExpectationForNotification() {
        let exp = XCTNSNotificationExpectation(name: .init("MyNotification"), object: nil)
        
    //        sut.postNotification()
        
        wait(for: [exp], timeout: 1)
    }

    func testInvertedExpectation() {
        let exp = expectation(description: #function)
        exp.isInverted = true
        
//        sut.maybeComplete {
//            exp.fulfill()
//        }
        
        wait(for: [exp], timeout: 0.1)
    }
}
