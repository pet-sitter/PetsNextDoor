//
//  PhotoCompressor.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import UIKit

struct PhotoConverter {
  
  static func convertUIImageToJpegData(image: UIImage, compressionQuality: CGFloat) -> Data? {
    return image.jpegData(compressionQuality: compressionQuality)
  }
}
