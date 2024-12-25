//
//  TextModifier.swift
//  34.Accessibility-SwiftUI
//
//  Created by Despo on 25.12.24.
//

import SwiftUI

extension Text {
  func styledText(_ textColor: Color, _ size: CGFloat = 16, _ weight: Font.Weight = .regular) -> some View {
    self
      .foregroundStyle(textColor)
      .font(.system(size: size))
      .fontWeight(weight)
    
  }
}
