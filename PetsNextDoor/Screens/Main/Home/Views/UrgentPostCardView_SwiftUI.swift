//
//  UrgentPostCardView_SwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/01/17.
//

import SwiftUI
import Kingfisher

struct UrgentPostCardViewModel: HashableViewModel {
  let mainImageUrlString: String?
  let postTitle: String
  let date: String
  let location: String
  let cost: String
  let postId: Int
}


struct UrgentPostCardView_SwiftUI: View {
  
  var viewModel: UrgentPostCardViewModel
  
  var body: some View {
    HStack(alignment: .center) {
      
      Spacer()
        .frame(width: PND.Metrics.defaultSpacing)
      
      KFImage(URL(string: viewModel.mainImageUrlString ?? ""))
        .placeholder {
          ProgressView()
        }
        .resizable()
        .frame(width: 88, height: 88)
        .scaledToFill()
        .cornerRadius(4)
                
      Spacer()
        .frame(width: 8)
      
      VStack(alignment: .leading) {
        Text(viewModel.postTitle)
          .font(.system(size: 16, weight: .bold))
        
        // 날짜
        HStack(spacing: 6) {
          Image(R.image.icon_cal)
            .resizable()
            .frame(width: 16, height: 16)
          
          Text(viewModel.date)
            .font(.system(size: 12, weight: .medium))
        }
        
        // 위치
        HStack(spacing: 6) {
          Image(R.image.icon_pin)
            .resizable()
            .frame(width: 16, height: 16)
          
          Text(viewModel.location)
            .font(.system(size: 12, weight: .medium))
        }
        
        // 페이
        HStack(spacing: 6) {
          Image(R.image.icon_pay)
            .resizable()
            .frame(width: 16, height: 16)
          
          Text(viewModel.cost)
            .font(.system(size: 12, weight: .medium))
        }
      }
      
      Spacer()
        .frame(width: PND.Metrics.defaultSpacing)
    }
    .frame(width: UIScreen.fixedScreenSize.width, height: 112, alignment: .leading)
    .contentShape(Rectangle())
  }
}

#Preview {
  UrgentPostCardView_SwiftUI(viewModel: .init(mainImageUrlString: "https://placedog.net/640/480?random", postTitle: "돌봄급구 구해요", date: "2020-10-29", location: "중곡동", cost: "10,500", postId: 0))
}


