//
//  VideoModel.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import Foundation


struct VideoModel: Codable {
    let id, title: String
    let hlsURL: String
    let fullURL: String
    let description, publishedAt: String
    let author: Author
}

// MARK: - Author
struct Author: Codable {
    let id, name: String
}
