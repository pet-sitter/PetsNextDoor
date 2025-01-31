//
//  CircularProfileImageView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/16.
//

import SwiftUI
import Kingfisher

struct CircularProfileImageView: View {
  
  var imageUrlString: String?
  
  var body: some View {
    KFImage(URL(string: imageUrlString ?? ""))
      .placeholder { Image(systemName: "person.crop.circle.fill") }
      .resizable()
      .scaledToFill()
      .frame(width: 74, height: 74)
      .clipShape(Circle())
  }
}

struct CircularProfileImage_Previews: PreviewProvider {
  static var previews: some View {
    CircularProfileImageView(imageUrlString: "")
  }
}
