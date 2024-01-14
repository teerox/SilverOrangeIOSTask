//
//  ViewModel.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import Foundation
import Combine
import SwiftUI
import MarkdownKit
import AVFoundation
import CoreMedia

let timeScale = CMTimeScale(1000)
let time = CMTime(seconds: 0.5, preferredTimescale: timeScale)

enum PlayerScrubState {
    case reset
    case scrubStarted
    case scrubEnded(TimeInterval)
}

final class ViewModel: ObservableObject {
    
    private var publishers = Set<AnyCancellable>()
    private let repository: RequestProtocol!
    let markdownParser: MarkdownParser
    
    // class Publisher
    @Published var result: [VideoModel] = []
    @Published var currentIndex: Int = 0
    @Published var playerItem: VideoModel?
    @Published var isNextButtonActive: Bool = false
    @Published var isPreviousButtonActive: Bool = false
    @Published var dataLoadedSuccessfully: Bool = false
    @Published var showLoader: Bool = false
    @Published var playerPaused = true
    
    var buttonToDisplay: String {
        return playerPaused ? "play.circle.fill" : "pause.circle.fill"
    }
    
    init(with repository: RequestProtocol = Repository(),
         markdownParser: MarkdownParser = MarkdownParser()) {
        self.repository = repository
        self.markdownParser = markdownParser
        self.markdownParser.addCustomElement(MarkdownSubreddit())
    }
    
    /// - This method makes fetches data from the end point.
    /// - Author: Anthony Odu 13/01/2024
    func fetchData() {
        showLoader = true
        dataLoadedSuccessfully = false
        repository.fetchAllData()
            .sink { [weak self] _ in
                self?.showLoader = false
            } receiveValue: { [weak self] value in
                guard let self = self else { return }
                self.result = value
                self.dataLoadedSuccessfully = true
                self.result = self.sortByDate()
            }
            .store(in: &publishers)

    }
    
    /// - This method makes is used to sort the api response by date
    /// - Returns: returns sorted Array of VideoModel result
    /// - Author: Anthony Odu 13/01/2024
    func sortByDate() -> [VideoModel] {
          let dateFormatter = DateFormatter()
          dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

          result.sort { (video1, video2) -> Bool in
              if let date1 = dateFormatter.date(from: video1.publishedAt),
                 let date2 = dateFormatter.date(from: video2.publishedAt) {
                  return date1 < date2
              }
              return false
          }
        return result
      }

    
    /// Move to the next item in the list and update the UI.
    /// - Author: Anthony Odu 13/01/2024
    func showNextItem() {
        guard !result.isEmpty else {
            return // Ensure the result array is not empty
        }

        currentIndex += 1
        
    }

    /// Move to the previous item in the list and update the UI.
    /// - Author: Anthony Odu 13/01/2024
    func showPreviousItem() {
        guard !result.isEmpty else {
            return // Ensure the result array is not empty
        }

        currentIndex -= 1
    }

    
    /// Using the markdownkit library by passing a md text and generating
    /// an NSAttributedString which will be used in the textview
    /// - Parameters:
    ///   - markdownString: mark down string used by the method
    /// - Returns: returns NSAttributedString
    /// - Author: Anthony Odu 13/01/2024
    func parseString(markdownString: String) -> NSAttributedString {
        let attributtedString : NSAttributedString = markdownParser.parse(markdownString)
           return attributtedString
    }
}

