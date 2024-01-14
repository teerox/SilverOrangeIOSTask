//
//  VideoPlayerView.swift
//  VideoPlayerSwiftUI
//
//  Created by Anthony Odu on 14/01/2024.
//

import SwiftUI
import AVKit


struct VideoPlayerView: View {
    
    
    @ObservedObject private var viewModel: ViewModel = ViewModel()
    
    @State private var noVideoLoaded = false
    @State private var showcontrols = true
    @State private var isPlaying = false
    @State private var markdownString = ""
    @State private var title: String = ""
    @State private var author: String = ""
    @State var progres: Float = 0
    
    // Computed properties to determine button sensitivity
    private var isNextButtonEnabled: Bool {
        return viewModel.result.count > 1 && viewModel.currentIndex < viewModel.result.count - 1
    }
    
    private var isPreviousButtonEnabled: Bool {
        return viewModel.result.count > 1 && viewModel.currentIndex > 0
    }
    
    
    /// - Setup the navigation bar to match the wireframe design
    /// - Author: Anthony Odu 14/01/2024
    init() {
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = UIColor(.black)
        coloredAppearance.titleTextAttributes = [.foregroundColor: UIColor(.white)]
        UINavigationBar.appearance().standardAppearance = coloredAppearance
        UINavigationBar.appearance().compactAppearance = coloredAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = coloredAppearance
        UINavigationBar.appearance().tintColor = UIColor(.blue)
    }
    
    @State private var player: MediaPlayer?

    var body: some View {
        NavigationView {
            VStack {
                ZStack {
                    HStack {
                        VStack{
                            Spacer()
                        }
                        .frame(height: 300)
                        Spacer()
                    }
                    if viewModel.showLoader {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .foregroundColor(.white)
                            .padding()
                    } else {
                        if noVideoLoaded {
                            Text("Unable to play video")
                                .foregroundColor(.red)
                                .padding(.bottom, 80)
                        } else {
                            if let player = player?.player {
                                CustomVideoPlayer(player: player)
                                    .frame(height: 300, alignment: .center)
                            } else {
                                Text("Unable to play video")
                                    .foregroundColor(.red)
                                    .padding(.bottom, 80)
                            }
                        }
                    }
                    
                    HStack(spacing: 50) {
                        Button(action:  viewModel.showPreviousItem , label: {
                            Image("previous")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        })
                        .disabled(!isPreviousButtonEnabled)
                        
                        Button(action: {
                            viewModel.playerPaused.toggle()
                            if viewModel.playerPaused {
                                player?.pause()
                            }
                            else {
                                player?.play()
                            }
                        }, label: {
                            Image(viewModel.buttonToDisplay)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        })
                        
                        Button(action: viewModel.showNextItem, label: {
                            Image("next")
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 50, height: 50)
                                .foregroundColor(.white)
                        })
                        .disabled(!isNextButtonEnabled)
                        
                    }
                    .opacity(showcontrols ? 1 : 0)
                    
                    /// This is a bit of a hack, but it takes a moment for the AVPlayerItem to load
                    /// the duration, so we need to avoid adding the slider until the range
                    /// (0...self.player.duration) is not empty.
                    VStack {
                        Spacer()
                        if let player = player {
                            CustomSliderView(player: player, progres: $progres)
                                .opacity(0)
                        } else {
                            EmptyView()
                        }
                    }
                }
                .frame(height: 300)
                .background(Color.black)
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.90)) {
                        showcontrols.toggle()
                    }
                    resetTimer()
                }
                
                ScrollView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text(title)
                                .font(.title3)
                            Text(title)
                                .font(.callout)
                            TextWithAttributedString(attributedText: viewModel.parseString(markdownString: markdownString))
                                .layoutPriority(1)
                                .background(Color.clear)
                            
                        }
                        .padding()
                        Spacer()
                    }
                }
            }
            
            .onChange(of: viewModel.currentIndex) { currentItem in
                player?.pause()
                viewModel.playerPaused = true
                if let videoURL = URL(string: viewModel.result[viewModel.currentIndex].fullURL) {
                    noVideoLoaded = false
                    player = MediaPlayer(url: videoURL)
                    player?.play()
                    viewModel.playerPaused = false
                } else {
                    noVideoLoaded = true
                }
                markdownString = viewModel.result[viewModel.currentIndex].description
                title = viewModel.result[viewModel.currentIndex].title
            }
            
            .onChange(of: viewModel.dataLoadedSuccessfully) { loaded in
                if loaded {
                    if let videoURL = URL(string: viewModel.result.first?.fullURL ?? "") {
                        noVideoLoaded = false
                        player = MediaPlayer(url: videoURL)
                        viewModel.playerPaused = true
                        player?.pause()
                    } else {
                        noVideoLoaded = true
                    }
                    markdownString = viewModel.result.first?.description ?? ""
                    title = viewModel.result.first?.title ?? ""
                }
            }
            .onChange(of: progres, perform: { value in
                if value == 1 {
                    playvideo()
                }
            })
            .onAppear(perform: {
                viewModel.fetchData()
                resetTimer()
            })
            .ignoresSafeArea(edges: .bottom)
            .navigationTitle("Video Player")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    private func playvideo() {
        player?.pause()
        viewModel.playerPaused = true
        if let videoURL = URL(string: viewModel.result[viewModel.currentIndex].fullURL) {
            noVideoLoaded = false
            player = MediaPlayer(url: videoURL)
            viewModel.playerPaused = true
            player?.pause()
            viewModel.playerPaused = false
        } else {
            noVideoLoaded = true
        }
    }
    
    private func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 7.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.90)) {
                showcontrols = false
            }
        }
    }
    
    private func resetTimer() {
        startTimer()
    }
}

#Preview {
    VideoPlayerView()
}


