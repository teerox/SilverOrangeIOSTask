//
//  MockNetworkManager.swift
//  VideoPlayerSwiftUITests
//
//  Created by Anthony Odu on 14/01/2024.
//

import Combine
import Foundation
import XCTest
@testable import VideoPlayerSwiftUI

// Mock implementation of the network service
class MockNetworkManager: ServiceProtocol {

    /// This method mocks a network request
    /// - Parameters:
    ///   - url: url for request
    ///   - method: methods for POST, GET, PUT and DELETE
    ///   - parameters: request body as dictionary
    /// - Returns: returns AnyPublisher with the data response
    /// - Author: Anthony Odu 13/01/2024

    func makeRequest<T>(url: String, method: CustomHTTPMethod) -> AnyPublisher<T, Error> where T : Decodable, T : Encodable {
        // Assuming you want to return mock data for a specific URL
        if url == "/api" && T.self == VideoModel.self {
            
            let responseModel = [VideoModel(
                id: "123456",
                title: "Sample Video",
                hlsURL: "https://example.com/sample-video/hls",
                fullURL: "https://example.com/sample-video",
                description: "This is a sample video description.",
                publishedAt: "2024-01-14T12:30:00Z",
                author: Author(id: "789", name: "John Doe")
            )]
            return Just(responseModel as! T)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        } else {
            // Handle other cases or return an error for unexpected requests
            return Fail(error: NSError(domain: "MockNetworkManager", code: 404, userInfo: nil))
                .eraseToAnyPublisher()
        }
    }
}
