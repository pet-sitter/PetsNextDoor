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
    HStack(alignment: .top, spacing: 0) {
      
      VStack(alignment: .leading, spacing: 0) {
        
        HStack(spacing: 4) {
          
          Image(.iconFixBlack)
            .resizable()
            .frame(width: 20, height: 20)
          
          Text(MockDataProvider.randomAuthorName)
            .font(.system(size: 16, weight: .bold))
          
          Text("정기")
            .font(.system(size: 12, weight: .semibold))
            .padding(4)
            .background(PND.DS.gray20)
            .cornerRadius(4)
        }
        
        Spacer().frame(height: 4)
        
        Text(MockDataProvider.randomChatMessage)
          .font(.system(size: 14, weight: .medium))
          .lineLimit(1)
          .multilineTextAlignment(.leading)
        
        Spacer().frame(height: 8)
        
        // 프사 모음
        HStack(spacing: -4) {
          ForEach(0..<3, id: \.self) { index in
            
            KFImage.url(MockDataProvider.randomePetImageUrl)
              .resizable()
              .scaledToFill()
              .frame(width: 20, height: 20)
              .clipShape(Circle())
              .background(
                Circle()
                  .fill(PND.DS.commonWhite)
                  .frame(width: 24, height: 24)
              )
          }
        }
        
      }
      
      Spacer()
      
      VStack(alignment: .trailing, spacing: 0) {
        Text("\(MockDataProvider.randomCount)분 전")
          .font(.system(size: 12, weight: .medium))
        
        Spacer().frame(height: 7)
        
        Text("\(MockDataProvider.randomCount)")
          .padding(.horizontal, 8)
          .padding(.vertical, 4)
          .lineLimit(1)
          .frame(height: 22)
          .frame(minWidth: 24)
          .foregroundStyle(PND.DS.primary)
          .font(.system(size: 12, weight: .bold))
          .background(PND.DS.commonBlack)
          .cornerRadius(17)
      }
      
    }
    .frame(height: Self.height)
    .listRowInsets(EdgeInsets())
    .contentShape(Rectangle())
    .padding(.horizontal, PND.Metrics.defaultSpacing)
    .swipeActions(edge: .leading) {
      Button(action: {
        
      }, label: {
        Image(.iconFix)
          .resizable()
          .frame(width: 24, height: 24)
      })
      .tint(PND.DS.lightGreen)
    }
    .swipeActions(edge: .trailing) {
      Button(action: {
        
      }, label: {
        Text("나가기")
          .font(.system(size: 12, weight: .bold))
          .tint(.red)
      })
      .tint(.red)
    }
  }
}

#Preview {
  ChatRoomView()
}
