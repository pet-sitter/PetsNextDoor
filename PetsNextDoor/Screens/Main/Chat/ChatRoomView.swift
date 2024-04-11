//
//  ChatRoomView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/04/11.
//

import SwiftUI
import Kingfisher

struct ChatRoomView: View {
  
  static let height: CGFloat = 94
  
  var body: some View {
    HStack(spacing: 0) {
      KFImage(MockDataProvider.randomePetImageUrl)
        .placeholder {
          ProgressView()
        }
        .resizable()
        .scaledToFill()
        .frame(width: 52, height: 52)
        .clipShape(Circle())
      
      Spacer().frame(width: 12)
      
      HStack(alignment: .top, spacing: 0) {
        VStack(alignment: .leading, spacing: 0) {
          
          Text("Author")
          
          Spacer().frame(height: 4)
          
          Text("chat test")
          
        }
        
        Spacer()
        
        VStack(alignment: .trailing, spacing: 0) {
          Text("1분 전")
          
          Text("32")
            .padding(.horizontal, 4)
            .padding(.vertical, 1)
            .lineLimit(1)
            .frame(height: 15)
            .frame(minWidth: 15)
            .foregroundStyle(PND.DS.primary)
            .font(.system(size: 10, weight: .bold))
            .background(PND.DS.commonBlack)
            .cornerRadius(20)
        }
      }
    }
    .frame(height: Self.height)
    .listRowInsets(EdgeInsets())
    .contentShape(Rectangle())
    .padding(.horizontal, 24)
  }
}

#Preview {
  ChatRoomView()
}
