//
//  FullView.swift
//  34.Accessibility-SwiftUI
//
//  Created by Despo on 25.12.24.
//

import SwiftUI

struct FullMusicView: View {
  @Environment(\.dismiss) var mode
  @EnvironmentObject var vm: ContentViewModel
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.customRed, .customBlack],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      VStack {
        HStack {
          Image(systemName: "chevron.down")
            .foregroundStyle(.customWhite)
            .onTapGesture {
              mode()
            }
          
          Spacer()
          
          Text("My Album")
            .styledText(.customWhite, 14)
          
          Spacer()
          
          Image(systemName: "ellipsis")
            .foregroundStyle(.customWhite)
        }
        
        if let song = vm.singleSong() {
          VStack(spacing: 15) {
            Image(song.cover)
              .resizable()
              .scaledToFill()
              .frame(maxWidth: 350, maxHeight: 350)
              .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 6)
            
            HStack {
              VStack(alignment: .leading) {
                Text(song.name)
                  .styledText(.customWhite, 26, .bold)
                
                Text(song.author)
                  .styledText(.customGray, 16, .bold)
                
              }
              
              Spacer()
            }
            .frame(maxWidth: .infinity)
            
            VStack {
              SUIProgressView(
                currentProgres: $vm.currentSongProgress,
                currentSongDuration: vm.currentSongDuration
              )
              
              HStack {
                Text(vm.getDurationtInMinutes())
                  .styledText(.customGray, 16)
                
                Spacer()
                
                Text("-\(vm.getBackwardInMinutes())")
                  .styledText(.customGray, 16)
                
              }
              
              HStack {
                Button {
                  vm.isShuffled.toggle()
                  vm.isLooped = false
                } label: {
                  Image(systemName: "shuffle")
                    .foregroundStyle(vm.isShuffled ? .green : .customWhite)
                    .font(.system(size: 25))
                }
                
                Spacer()
                
                HStack {
                  Button {
                    vm.playPrev()
                  } label: {
                    Image(systemName: "backward.end.fill")
                  }
                  
                  Image(systemName: !vm.isPlaying ? "arrowtriangle.right.circle.fill" : "pause.circle.fill")
                    .onTapGesture {
                      vm.playAudio(with: song.songName, and: song.id)
                    }
                  
                  Button {
                    vm.playNext()
                  } label: {
                    Image(systemName: "forward.end.fill")
                  }
                }
                .font(.system(size: 50))

                
                Spacer()
                
                Image(systemName: "repeat")
                  .font(.system(size: 25))
                  .foregroundStyle(vm.isLooped ? .green : .customWhite)
                  .onTapGesture {
                    vm.isLooped.toggle()
                    vm.isShuffled = false
                  }
                
              }
              .foregroundStyle(.customWhite)
              .padding(.top, 5)
            }
          }
          .padding(.top, 70)
        }
        
        Spacer()
      }
      .padding(.horizontal, 15)
    }
  }
}
