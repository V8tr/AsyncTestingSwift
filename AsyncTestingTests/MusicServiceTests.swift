//
//  MusicServiceTests.swift
//  AsyncTestingTests
//
//  Created by Vadym Bulavin on 2/28/20.
//  Copyright © 2020 Vadym Bulavin. All rights reserved.
//

import XCTest
@testable import AsyncTesting

class MusicServiceTests: XCTestCase {
    
    struct DummyError: Error {}

    func testSearch() {
        let httpClient = MockHTTPClient()
        let sut = MusicService(httpClient: httpClient)
        
        sut.search("A") { _ in }
        
        XCTAssertTrue(httpClient.executeCalled)
        XCTAssertEqual(httpClient.inputRequest, .search(term: "A"))
    }

    func testSearchWithSuccessResponse() throws {
        let expectedTracks = [Track(trackName: "A", artistName: "B")]
        let response = try JSONEncoder().encode(SearchMediaResponse(results: expectedTracks))

        let httpClient = MockHTTPClient()
        httpClient.result = .success(response)

        let sut = MusicService(httpClient: httpClient)

        var result: Result<[Track], Error>?

        sut.search("A") { result = $0 }

        XCTAssertEqual(result?.value, expectedTracks)
    }

    func testSearchWithFailureResponse() throws {
        let httpClient = MockHTTPClient()
        httpClient.result = .failure(DummyError())

        let sut = MusicService(httpClient: httpClient)

        var result: Result<[Track], Error>?

        sut.search("A") { result = $0 }

        XCTAssertTrue(result?.error is DummyError)
    }
    
    func testSearchBefore() {
        let sut = MusicServiceWithoutDependency()
        
        sut.search("A") { _ in }
        
        let lastRequest = URLSession.shared.tasks.last?.currentRequest
        XCTAssertEqual(lastRequest?.url, URLRequest.search(term: "A").url)
    }
    
    func testSearchAfterWithSuccess() throws {
        let expectedTracks = [Track(trackName: "A", artistName: "B")]
        let response = try JSONEncoder().encode(SearchMediaResponse(results: expectedTracks))
        
        let sut = MusicServiceWithoutDependency()
        
        let result = sut.parse(data: response, error: nil)
        
        XCTAssertEqual(result.value, expectedTracks)
    }
    
    func testSearchAfterWithFailure() {
        let sut = MusicServiceWithoutDependency()
        
        let result = sut.parse(data: nil, error: DummyError())
        
        XCTAssertTrue(result.error is DummyError)
    }

}

class MockHTTPClient: HTTPClient {
    var inputRequest: URLRequest?
    var executeCalled = false
    var result: Result<Data, Error>?
    
    func execute(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        executeCalled = true
        inputRequest = request
        result.map(completion)
    }
}

extension URLSession {
    
    var tasks: [URLSessionTask] {
        var tasks: [URLSessionTask] = []
        let group = DispatchGroup()
        group.enter()
        getAllTasks {
            tasks = $0
            group.leave()
        }
        group.wait()
        return tasks
    }
}
