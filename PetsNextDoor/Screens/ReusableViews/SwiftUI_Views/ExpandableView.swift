//
//  ExpandableView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 10/24/24.
//

import SwiftUI

struct ExpandableView: View {
  
  @Binding var isExpanded: Bool
  @Binding var isFocused: Bool
  
  var thumbnail: ThumbnailView
  var expanded: ExpandedView
  
  var body: some View {
    ZStack {
      VStack {
        thumbnail
        if isExpanded {
          expanded
        }
      }
    }
    .padding(.horizontal, 16)
    .padding(.vertical, 20)
    .background(PND.DS.commonWhite)
    .cornerRadius(8)
    .padding(.horizontal, PND.Metrics.defaultSpacing)
    .if(isFocused, { view in
      view
        .overlay {
          RoundedRectangle(cornerRadius: 8)
            .inset(by: 0.5)
            .stroke(PND.DS.primary, lineWidth: 1)
            .padding(.horizontal, PND.Metrics.defaultSpacing)
        }
    })
    .onChange(of: isFocused, { oldValue, newValue in
      withAnimation (.spring(response: 0.5)){
        isExpanded.toggle()
      }
    })
    .onTapGesture {
      withAnimation (.spring(response: 0.5)){
        isExpanded.toggle()
      }
    }
  }
}

struct ExpandedView: View {
  var id = UUID()
  @ViewBuilder var content: any View
  
  var body: some View {
    ZStack {
      AnyView(content)
    }
  }
}

struct ThumbnailView: View, Identifiable {
  var id = UUID()
  @ViewBuilder var content: any View
  
  var body: some View {
    ZStack {
      AnyView(content)
    }
  }
}
