//
//  MeetingCardViewSwiftUI.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/11/21.
//

import SwiftUI

struct MeetingCardViewSwiftUI: View {
  
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
        
        HStack(alignment: .center, spacing: 5) {
          
          Spacer()
            .frame(width: 4)
          
          Image(systemName: "person.2.fill")
            .frame(width: 7, height: 7)
            .foregroundColor(PND.Colors.commonOrange.asColor)
          
          Spacer()
            .frame(width: 4)
        
          Text("6/10")
            .font(.system(size: 12, weight: .medium))
          
          Spacer()
            .frame(width: 0.1)

          Text("방금 활동")
            .font(.system(size: 12, weight: .medium))
            .foregroundColor(PND.Colors.commonBlue.asColor)
          
          
            
        }
        
        Spacer()
          .frame(height: 25)
        
        HStack(alignment: .center, spacing: 5) {
          
          Text("훈련")
            .font(.system(size: 12, weight: .medium))

            .overlay {
              RoundedRectangle(cornerRadius: 4)
                .stroke(Color(.systemGray4), lineWidth: 1)
            }

  
        }
      }
      Spacer(minLength: PND.Metrics.defaultSpacing)
      
    }
    .ignoresSafeArea(edges: .all)
  }
}

struct MeetingCardViewSwiftUI_Previews: PreviewProvider {
  static var previews: some View {
    MeetingCardViewSwiftUI()
  }
}


