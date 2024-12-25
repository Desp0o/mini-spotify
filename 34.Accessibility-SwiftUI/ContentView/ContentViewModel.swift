//
//  ContentViewModel.swift
//  34.Accessibility-SwiftUI
//
//  Created by Despo on 25.12.24.
//

import Foundation
import AVFoundation
import Combine

@Observable
final class ContentViewModel: ObservableObject {
  var audioPlayer: AVAudioPlayer?
  var currentSongDuration: TimeInterval = 0
  var currentSongProgress: TimeInterval = 0
  var currentBackWardCount: TimeInterval = 0
  var isPlaying = false
  var isLooped = false
  var isShuffled = false
  private var wasPaused = false
  private var musicCancellables: [UUID: AnyCancellable] = [:]
  private var backWardCancellables: [UUID: AnyCancellable] = [:]
  private var currentSongID = UUID()
  
  var mySongs: [SongModel] = [
    SongModel(cover: "naiveMan", name: "Small Talks", author: "Naive Man", songName: "smallTalks"),
    SongModel(cover: "muntity", name: "My Favorite Mutiny", author: "The Coup", songName: "mutiny"),
    SongModel(cover: "gunsNroses", name: "Paradise City", author: "Guns N' Roses", songName: "paradiseCity"),
    SongModel(cover: "hegotagame", name: "He Got Game", author: "Public Enemy", songName: "heGotGame"),
    SongModel(cover: "creedence", name: "Fortunate Son", author: "Creedence Clearwater Revival", songName: "fortunateSon"),
    SongModel(cover: "springfield", name: "Son Of A Preacher Man", author: "Dusty Springfield", songName: "sonOfPreacher"),
    SongModel(cover: "tribe", name: "Can I Kick", author: "A Tribe Called Quest", songName: "caniKick")
  ]
  
  func playAudio(with songName: String, and songID: UUID) {
    if currentSongID == songID, let audioPlayer = audioPlayer {
      isPlaying.toggle()
      if isPlaying {
        audioPlayer.play()
        startMusicTimer(with: songID, duration: currentSongDuration)
      } else {
        audioPlayer.pause()
        stopMusic(width: songID)
      }
      
      return
    }
    
    audioPlayer?.stop()
    currentSongProgress = 0
    stopMusic(width: currentSongID)
    currentSongID = songID
    
    guard let audioFilePath = Bundle.main.path(forResource: songName, ofType: "mp3") else {
      print("Audio file not found")
      return
    }
    
    let audioURL = URL(fileURLWithPath: audioFilePath)
    
    do {
      audioPlayer = try AVAudioPlayer(contentsOf: audioURL)
      
      if let audioPlayer = audioPlayer {
        audioPlayer.numberOfLoops = isLooped ? -1 : 0
        currentSongDuration = audioPlayer.duration
        currentBackWardCount = audioPlayer.duration
        
        audioPlayer.play()
        startMusicTimer(with: songID, duration: currentSongDuration)
        isPlaying = true
      }
    } catch {
      print("Failed to initialize audio player: \(error.localizedDescription)")
    }
  }
  
  func startMusicTimer(with id: UUID, duration: TimeInterval) {
    backwardCount()
    musicCancellables[id]?.cancel()
    musicCancellables[id] = Timer.publish(every: 0.5, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        if self?.currentSongProgress ?? 0 >= duration {
          self?.stopMusic(width: id)
        } else {
          self?.currentSongProgress += 0.5
        }
      }
  }
  
  private func backwardCount() {
    backWardCancellables[currentSongID]?.cancel()
    backWardCancellables[currentSongID] = Timer.publish(every: 0.5, on: .main, in: .common)
      .autoconnect()
      .sink { [weak self] _ in
        if self?.currentBackWardCount ?? 0 <= 0 {
          self?.stopMusic(width: self?.currentSongID ?? UUID())
          self?.currentBackWardCount = self?.currentSongDuration ?? 0
          self?.currentSongProgress = 0
          self?.isPlaying = false
          
          if self?.isLooped == true {
            guard let index = self?.mySongs.firstIndex(where: { $0.id == self?.currentSongID }) else {return}
            
            let currentSong = self?.mySongs[index]
            self?.playAudio(with: currentSong?.songName ?? "", and: currentSong?.id ?? UUID())
          }
          
          if self?.isShuffled == true {
            self?.shuffleMusic()
          }
        } else {
          self?.currentBackWardCount -= 0.5
        }
      }
  }
  
  private func stopMusic(width id: UUID) {
    wasPaused = true
    musicCancellables[id]?.cancel()
    backWardCancellables[id]?.cancel()
  }
  
  func singleSong() -> SongModel? {
    guard let index = mySongs.firstIndex(where: { song in
      song.id == currentSongID
    }) else {
      return  nil
    }
    
    return mySongs[index]
  }
  
  func playNext() {
    var nextSong: SongModel?
    guard let index = mySongs.firstIndex(where: { $0.id == currentSongID }) else {return}
    
    if index < mySongs.count - 1 {
      nextSong = mySongs[index + 1]
    } else {
      nextSong = mySongs[0]
    }
    
    guard let next = nextSong else { return }
    playAudio(with: next.songName, and: next.id)
  }
  
  func playPrev() {
    var prevSong: SongModel?
    guard let index = mySongs.firstIndex(where: { $0.id == currentSongID }) else {return}
    
    if index > 0 {
      prevSong = mySongs[index - 1]
    } else {
      let fullLength = mySongs.count
      prevSong = mySongs[fullLength - 1]
    }
    
    guard let song = prevSong else { return }
    playAudio(with: song.songName, and: song.id)
  }
  
  func shuffleMusic() {
    let randomIndex = Int.random(in: 0..<mySongs.count)
    let randomSong = mySongs[randomIndex]
    
    playAudio(with: randomSong.songName, and: randomSong.id)
  }
  
  private func formatIntervalToSeconds(timeInterval: TimeInterval) -> String {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.minute, .second]
    var formattedTime = formatter.string(from: timeInterval) ?? "00:00"
    
    let minutes = Int(timeInterval) / 60
    let seconds = Int(timeInterval) % 60
    
    formattedTime = String(format: "%2d:%02d", minutes, seconds)
    
    return formattedTime
  }
  
  func getDurationtInMinutes() -> String {
    formatIntervalToSeconds(timeInterval: currentSongDuration)
  }
  
  func getBackwardInMinutes() -> String {
    formatIntervalToSeconds(timeInterval: currentBackWardCount)
  }
}

