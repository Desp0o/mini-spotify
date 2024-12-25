//
//  SongModel.swift
//  34.Accessibility-SwiftUI
//
//  Created by Despo on 25.12.24.
//

import SwiftUI

struct SongModel: Identifiable, Hashable {
    let id = UUID()
    let cover: String
    let name: String
    let author: String
    let songName: String
}
