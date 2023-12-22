//
//  CircularProfileImageView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/16.
//

import SwiftUI

struct CircularProfileImageView: View {
  
  let imageUrlString: String
  
  var body: some View {
    AsyncImage(url: URL(string: imageUrlString)) { image in
      image.resizable()
    } placeholder: {
      ProgressView()
    }
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
