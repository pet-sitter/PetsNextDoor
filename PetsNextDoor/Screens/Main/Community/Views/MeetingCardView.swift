//
//  MeetingCardView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/21.
//

import SwiftUI

struct MeetingCardViewModel: HashableViewModel {
	
}

struct MeetingCardView: View {
  
  var body: some View {
    HStack(alignment: .center) {
      
      Spacer()
        .frame(width: PND.Metrics.defaultSpacing)
      
      Image("dog_test")
        .resizable()
        .scaledToFit()
        .frame(width: 88, height: 88)
        .cornerRadius(4)
      
      Spacer()
        .frame(width: 8)
      

      VStack(alignment: .leading) {
        
        Text("푸들을 사랑하는 모임")
          .font(.system(size: 16, weight: .bold))
        
        HStack(alignment: .center, spacing: 4) {
          
					Image(R.image.person_2)
						.resizable()
						.scaledToFit()
						.frame(width: 16, height: 16)
        
          Text("6/10")
            .font(.system(size: 12, weight: .medium))
          
          Spacer()
            .frame(width: 1)

          Text("방금 활동")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(PND.Colors.commonBlue.asColor)
        }
        
        Spacer()
          .frame(height: 20)
				
				
				HStack(alignment: .center, spacing: 5) {
					
					Text("훈련")
						.padding(4)
						.lineLimit(1)
						.frame(height: 22)
						.font(.system(size: 12, weight: .medium))
						.background(Color(hex: "#F3F3F3"))
						.cornerRadius(4)
						.lineLimit(1)
						.foregroundColor(.black)
        }
				
				
				
      }
      Spacer(minLength: PND.Metrics.defaultSpacing)
      
    }
    .ignoresSafeArea(edges: .all)
  }
}

//#Preview {
//	MeetingCardView()
//}

//struct MeetingCardViewSwiftUI_Previews: PreviewProvider {
//  static var previews: some View {
//    MeetingCardViewSwiftUI()
//  }
//}


