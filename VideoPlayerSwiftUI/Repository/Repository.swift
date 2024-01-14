//
//  Repository.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import Foundation
import Combine

protocol RequestProtocol {
    func fetchAllData() -> AnyPublisher<[VideoModel], Error>
}


class Repository: RequestProtocol {
    
    private let networkManger: ServiceProtocol!
    var cancellableSet: Set<AnyCancellable> = []
    
    /// Initialze Network Manager and cache manager here
    /// - Parameters: For Testing Purpose mocked `networkManger`
    /// can be injected into this viewModel
    ///   - networkManger: Fetch result from Api
    /// - Author: Anthony Odu 14/01/2024
    init(with networkManger: ServiceProtocol = NetworkManager.shared()) {
        self.networkManger = networkManger
    }
    
    /// - Returns: returns AnyPublisher for video data
    /// - Author: Anthony Odu 14/01/2024
    func fetchAllData() -> AnyPublisher<[VideoModel], Error> {
        let result: AnyPublisher<[VideoModel], Error> = networkManger.makeRequest(url: "/videos",method: .get)
        
        return result
            .eraseToAnyPublisher()
    }
}

