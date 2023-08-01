//
//  APICallsTests.swift
//  APICallsTests
//
//  Created by Miguel Fonseca on 27/07/23.
//

import XCTest
import Combine

@testable import Justo_Coding_Challenge

final class APICallsTests: XCTestCase {

    var sut: Networking?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()
        sut = Networking()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sut = nil
        try super.tearDownWithError()
    }

    func testFetchPerson(){
        let expectation = XCTestExpectation(description: "Waiting for person API response")
        guard let networking = sut else {return}
        let cancellable: AnyCancellable = networking.fetchPerson()
            .sink { completion in
                if case .failure(let error) = completion {
                    XCTFail("API Call error: \(error.localizedDescription)")
                }
                
            } receiveValue: { result in
                XCTAssertNotNil(result.results.first, "First result is nil")
                expectation.fulfill()
            }
        
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }

}
