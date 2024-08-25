//
//  ChatImageViewer.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 8/25/24.
//

import Foundation
import SwiftUI
import Kingfisher

struct ChatImageViewer: View {
  
  @State private var currentPage: Int = 1
  @Environment(\.dismiss) private var dismiss
  
  @State var medias: [PND.Media]
  
  var body: some View {
    ScrollView(.horizontal) {
      LazyHStack(spacing: 0) {
        ForEach(medias.indices, id: \.self) { index in
          MagnifiableKFImageView(imageUrlString: medias[index].url ?? "")
            .frame(width: .screenWidth, height: .screenHeight * CGFloat(0.75))
            .scrollTransition(.interactive, axis: .horizontal) { effect, phase in
              effect
                .scaleEffect(phase.isIdentity ? 1.0 : 0.95)
            }
            .onAppear() {
              currentPage = index + 1
            }
        }
      }
      .scrollTargetLayout()
    }
    .background(
      Color.black
        .ignoresSafeArea(.all)
    )
    .scrollTargetBehavior(.viewAligned)
    .overlay(alignment: .bottom, content: {
      Text("\(currentPage)/\(medias.count)")
        .foregroundStyle(PND.DS.commonWhite)
        .font(.system(size: 16, weight: .bold))
    })
    .overlay(alignment: .top, content: {
      HStack {
        Button {
          dismiss()
        } label: {
          Image(systemName: "xmark")
        }

        Spacer()
        
        Button {
          guard let imageUrlString = medias[safe: currentPage - 1]?.url else { return }
          PhotoSaver().save(
            for: imageUrlString,
            onCompletion: {
              Toast.shared.present(title: "사진 저장 완료", symbolType: .checkmark)
            }
          )
          
        } label: {
          Text("저장")
            .font(.system(size: 16, weight: .regular))
        }
      }
      .foregroundStyle(PND.DS.commonWhite)
      .padding(.horizontal, PND.Metrics.defaultSpacing)
    })

  }
}

#Preview {
  ChatImageViewer(medias: [.init(id: 0, url: "https://s3.us-east-005.backblazeb2.com/pets-next-door-dev/media/53e8a0bc-cfd1-46ae-9249-3c9a929325c3.png"),
                           .init(id: 1, url: "https://s3.us-east-005.backblazeb2.com/pets-next-door-dev/media/53e8a0bc-cfd1-46ae-9249-3c9a929325c3.png")])
}



struct MagnifiableKFImageView: View {
  
  private let imageUrlString: String
  
  @State private var scale: CGFloat = 1
  @State private var lastScale: CGFloat = 1
  
  @State private var offset: CGPoint = .zero
  @State private var lastTranslation: CGSize = .zero
  
  init(imageUrlString: String) {
    self.imageUrlString = imageUrlString
  }
  
  public var body: some View {
    GeometryReader { proxy in
      ZStack {
        KFImage.url(URL(string: imageUrlString))
          .placeholder {
            ProgressView()
          }
          .resizable()
          .aspectRatio(contentMode: .fit)
          .scaleEffect(scale)
          .offset(x: offset.x, y: offset.y)
          .gesture(makeDragGesture(size: proxy.size))
          .gesture(makeMagnificationGesture(size: proxy.size))
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .edgesIgnoringSafeArea(.all)
    }
  }
  
  private func makeMagnificationGesture(size: CGSize) -> some Gesture {
    MagnificationGesture()
      .onChanged { value in
        let delta = value / lastScale
        lastScale = value
        
        // To minimize jittering
        if abs(1 - delta) > 0.01 {
          scale *= delta
        }
      }
      .onEnded { _ in
        lastScale = 1
        if scale < 1 {
          withAnimation {
            scale = 1
          }
        }
        adjustMaxOffset(size: size)
      }
  }
  
  private func makeDragGesture(size: CGSize) -> some Gesture {
    DragGesture()
      .onChanged { value in
        let diff = CGPoint(
          x: value.translation.width - lastTranslation.width,
          y: value.translation.height - lastTranslation.height
        )
        offset = .init(x: offset.x + diff.x, y: offset.y + diff.y)
        lastTranslation = value.translation
      }
      .onEnded { _ in
        adjustMaxOffset(size: size)
      }
  }
  
  private func adjustMaxOffset(size: CGSize) {
    let maxOffsetX = (size.width * (scale - 1)) / 2
    let maxOffsetY = (size.height * (scale - 1)) / 2
    
    var newOffsetX = offset.x
    var newOffsetY = offset.y
    
    if abs(newOffsetX) > maxOffsetX {
      newOffsetX = maxOffsetX * (abs(newOffsetX) / newOffsetX)
    }
    if abs(newOffsetY) > maxOffsetY {
      newOffsetY = maxOffsetY * (abs(newOffsetY) / newOffsetY)
    }
    
    let newOffset = CGPoint(x: newOffsetX, y: newOffsetY)
    if newOffset != offset {
      withAnimation {
        offset = newOffset
      }
    }
    self.lastTranslation = .zero
  }
}
