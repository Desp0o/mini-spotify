//
//  ContentView.swift
//  34.Accessibility-SwiftUI
//
//  Created by Despo on 25.12.24.
//

import SwiftUI

struct ContentView: View {
  @StateObject var vm = ContentViewModel()
  @State var isPresented = false
  @State private var isProgressVisible = false
  
  var body: some View {
    ZStack {
      LinearGradient(
        colors: [.customRed, .customBlack],
        startPoint: .top,
        endPoint: .bottom
      )
      .ignoresSafeArea()
      
      VStack(spacing: 15) {
        Image("cover")
          .resizable()
          .scaledToFill()
          .frame(width: 200, height: 200)
          .shadow(color: Color.black.opacity(0.6), radius: 6, x: 2, y: 4)
        
        VStack(spacing: 0) {
          HStack {
            Text("My Album")
              .styledText(.customWhite, 24, .bold)
            
            Spacer()
          }
          
          HStack {
            Image("hablo")
              .resizable()
              .scaledToFill()
              .frame(width: 25, height: 25)
              .clipShape(Circle())
              .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 4)
            
            Text("Hablo Escobar")
              .styledText(.customGray)
            Spacer()
          }
        }
        .padding(.horizontal, 15)
        
        List {
          ForEach(vm.mySongs, id: \.self) { song in
            SingleMusicView(
              cover: song.cover,
              songName: song.name,
              author: song.author
            )
            .listRowBackground(Color.clear)
            .listRowInsets(.init(top: 0, leading: 0, bottom: 10, trailing: 0))
            .frame(maxWidth: .infinity)
            .listRowSeparator(.hidden)
            .onTapGesture {
              vm.playAudio(with: song.songName, and: song.id)
              isProgressVisible = true
            }
          }
        }
        .listStyle(PlainListStyle())
        .padding(.horizontal, 15)
        .padding(.top, 20)
        .scrollIndicators(.hidden)
        
        Spacer()
        
        ProgressView()
          .offset(y: isProgressVisible ? -20 : UIScreen.main.bounds.height)
          .animation(.easeOut(duration: 0.5), value: isProgressVisible)
          .onTapGesture {
            isPresented = true
          }
      }
      .padding(.top, 20)
    }
    
    .fullScreenCover(isPresented: $isPresented) {
      FullMusicView()
    }
    .environment(vm)
    
  }
}

#Preview {
  ContentView()
}
