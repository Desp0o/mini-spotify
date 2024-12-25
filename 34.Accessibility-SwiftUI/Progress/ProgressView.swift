//
//  ProgressView.swift
//  34.Accessibility-SwiftUI
//
//  Created by Despo on 25.12.24.
//

import SwiftUI

struct ProgressView: View {
  @EnvironmentObject var vm: ContentViewModel
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1)), Color(#colorLiteral(red: 0.370555222, green: 0.3705646992, blue: 0.3705595732, alpha: 1))],
        startPoint: .leading,
        endPoint: .trailing
      )
      
      VStack {
        HStack {
          HStack {
            if let song = vm.singleSong() {
              Image(song.cover)
                .resizable()
                .scaledToFill()
                .frame(width: 30, height: 30)
                .clipShape(RoundedRectangle(cornerRadius: 6))
              
              VStack(alignment: .leading) {
                Text(song.name)
                  .foregroundStyle(.customWhite)
                  .font(.system(size: 16))
                
                Text(song.author)
                  .foregroundStyle(.customGray)
                  .font(.system(size: 14))
              }
            }
          }
          
          Spacer()
          
          HStack {
            Image(systemName: "hifispeaker.2")
              .font(.system(size: 18))
              .foregroundStyle(.customWhite)
            
            Button {
              vm.playAudio(
                with: vm.singleSong()?.songName ?? "",
                and: vm.singleSong()?.id ?? UUID()
              )
            } label: {
              Image(systemName: !vm.isPlaying ? "play.fill" : "pause.fill")
                .font(.system(size: 18))
                .foregroundStyle(.customWhite)
            }
          }
        }
        .padding(.top, 12)
        .padding(.horizontal, 12)
        
        SUIProgressView(
          currentProgres: $vm.currentSongProgress,
          currentSongDuration: vm.currentSongDuration
        )
        .padding(.horizontal, 12)
      }
    }
    .clipShape(RoundedRectangle(cornerRadius: 12))
    .padding(.horizontal, 15)
    .frame(height: 50)
  }
}


struct SUIProgressView: UIViewRepresentable {
  @Binding var currentProgres: TimeInterval
  var currentSongDuration: TimeInterval
  
  func makeUIView(context: Context) -> UIProgressView {
    let progressView = UIProgressView(progressViewStyle: .default)
    progressView.progress = 0.0
    progressView.tintColor = .customWhite
    progressView.backgroundColor = .customBlack
    return progressView
  }
  
  func updateUIView(_ uiView: UIProgressView, context: Context) {
    let scaledProgress = Float(currentProgres / currentSongDuration)
  
    UIView.animate(withDuration: TimeInterval(scaledProgress)) {
      uiView.setProgress(scaledProgress, animated: true)
    }
  }
}
