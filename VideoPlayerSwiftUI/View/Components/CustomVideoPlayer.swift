//
//  CustomVideoPlayer.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import SwiftUI
import AVKit
import Foundation

struct CustomVideoPlayer : UIViewControllerRepresentable {
     var player: AVPlayer

     func makeUIViewController(context: UIViewControllerRepresentableContext<CustomVideoPlayer>) -> AVPlayerViewController {
      
         let controller = AVPlayerViewController()
         controller.player = player
         controller.showsPlaybackControls = false
         return controller
     }

     func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<CustomVideoPlayer>) {
        uiViewController.player = player
     }
}
