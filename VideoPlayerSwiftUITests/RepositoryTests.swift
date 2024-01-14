//
//  RepositoryTests.swift
//  VideoPlayerSwiftUITests
//
//  Created by Anthony Odu on 14/01/2024.
//

import XCTest
@testable import VideoPlayerSwiftUI

final class RepositoryTests: XCTestCase {
    var repository: Repository!
    
    override func setUp() {
        super.setUp()
        let mockNetworkManager: ServiceProtocol = MockNetworkManager()
        repository = Repository(with: mockNetworkManager)
    }

    func testFetchAllDataWithMockData() {
        let expectation = XCTestExpectation(description: "Fetch data expectation")
        
        repository.fetchAllData()
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { videoModels in
                // Assert or perform any validations based on the expected mock data
               
                XCTAssertEqual(videoModels.count, 1)
            })
            .store(in: &repository.cancellableSet)
        wait(for: [expectation], timeout: 5.0)
    }
}
