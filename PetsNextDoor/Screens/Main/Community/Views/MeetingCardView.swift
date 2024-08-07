//
//  MeetingCardView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/21.
//

import SwiftUI
import UIKit

struct MeetingCardViewModel: HashableViewModel {
	
  let mainImage: UIImage
	let title: String
	let currentlyGatheredPeople: Int
	let totalGatheringPeople: Int
	let activityStatus: String
	var tags: [String]
}

struct MeetingCardView: View {
	
  var viewModel: MeetingCardViewModel

	var body: some View {
		HStack(alignment: .center) {
			
			Spacer()
        .frame(width: PND.Metrics.defaultSpacing)
      
      Image(uiImage: viewModel.mainImage)
        .resizable()
        .scaledToFit()
        .frame(width: 88, height: 88)
        .cornerRadius(4)
      
      Spacer()
        .frame(width: 8)
      
      VStack(alignment: .leading) {
				Text(viewModel.title)
          .font(.system(size: 16, weight: .bold))
        
        HStack(alignment: .center, spacing: 4) {
          
          Image(.person2)
						.resizable()
						.scaledToFit()
						.frame(width: 16, height: 16)
        
					Text("\(viewModel.currentlyGatheredPeople)/\(viewModel.totalGatheringPeople)")
            .font(.system(size: 12, weight: .medium))
          
          Spacer()
            .frame(width: 1)

					Text(viewModel.activityStatus)
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(PND.Colors.commonBlue.asColor)
        }
        
        Spacer()
          .frame(height: 20)
				
				HStack(alignment: .center, spacing: 5) {
					
					ForEach(viewModel.tags, id: \.self) { tag in
						Text(tag)
							.padding(4)
							.lineLimit(1)
							.frame(height: 22)
							.font(.system(size: 12, weight: .medium))
              .background(PND.Colors.gray20.asColor)
							.cornerRadius(4)
							.foregroundColor(.black)
					}
					
        }
      }
      Spacer(minLength: PND.Metrics.defaultSpacing)
      
    }
    .ignoresSafeArea(edges: .all)
  }
}

//#Preview {
//  MeetingCardView(viewModel: .init(mainImage: UIImage(named: "dog_test")!, title: "푸들을 짱 사랑하는 모임", currentlyGatheredPeople: 7, totalGatheringPeople: 10, activityStatus: "방금 활동", tags: ["훈련", "케어초보"]))
//}
//
//
