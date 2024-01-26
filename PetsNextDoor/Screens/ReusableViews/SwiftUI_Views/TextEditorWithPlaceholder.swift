//
//  TextEditorWithPlaceholder.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/12.
//

import SwiftUI

struct TextEditorWithPlaceholder: View {
  
  @Binding var text: String
  let placeholder: String
  
  var body: some View {
    ZStack(alignment: .leading) {
      if text.isEmpty {
        VStack {
          Text(placeholder)
            .padding(.top, 10)
            .padding(.leading, 6)
            .foregroundStyle(.black)
          Spacer()
        }
      }
      
      VStack {
        TextEditor(text: $text)
          .font(.system(size: 16, weight: .regular))
          .opacity(text.isEmpty ? 0.7 : 1)
          .tint(.primary)
        Spacer()
      }
    }
  }
}

