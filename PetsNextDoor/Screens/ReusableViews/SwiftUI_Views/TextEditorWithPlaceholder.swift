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
      .background(Color.gray20)
      .cornerRadius(8)
    }
  }
}

struct TextEditorWithBackground: View {
  
  @Binding var text: String
  let placeholder: String
  
  var body: some View {
    ZStack {
      if text.isEmpty {
        TextEditor(text: .constant(placeholder))
          .font(.body)
          .foregroundColor(.gray)
          .disabled(true)
          .padding(20)
          .scrollContentBackground(.hidden)
      }
      TextEditor(text: $text)
        .font(.body)
        .opacity(self.text.isEmpty ? 0.25 : 1)
        .padding(20)
        .scrollContentBackground(.hidden)
    }
    .background(Color.gray20)
    .cornerRadius(8)
  }
}

