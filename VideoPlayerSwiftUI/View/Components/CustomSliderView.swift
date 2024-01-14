//
//  CustomSliderView.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import Foundation
import SwiftUI
import Combine

struct CustomSliderView: View {
    @ObservedObject var viewModel: PlayerSliderViewModel
    @Binding var progres: Float
    
    init(player: MediaPlayer, progres: Binding<Float>) {
        viewModel = .init(player: player)
        self._progres = progres
    }
    
    var body: some View {
        Slider(value: $viewModel.progressValue) { didChange in
            viewModel.didSliderChanged(didChange)
        }
        .onChange(of: viewModel.progressValue, perform: { value in
            progres = value
        })
    }
}

class PlayerSliderViewModel: ObservableObject {
    @Published var progressValue: Float = 0
    
    var player: MediaPlayer
    var acceptProgressUpdates = true
    var subscriptions: Set<AnyCancellable> = .init()
    
    init(player: MediaPlayer) {
        self.player = player
        listenToProgress()
    }
    
    private func listenToProgress() {
        player.currentProgressPublisher.sink { [weak self] progress in
            guard let self = self,
                  self.acceptProgressUpdates else { return }
            self.progressValue = progress
                
        }.store(in: &subscriptions)
    }
    
    func didSliderChanged(_ didChange: Bool) {
        acceptProgressUpdates = !didChange
        if didChange {
            player.pause()
        } else {
            player.seek(to: progressValue)
            player.play()
        }
    }
}
