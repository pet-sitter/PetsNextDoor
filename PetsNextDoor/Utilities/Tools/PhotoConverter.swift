//
//  PhotoCompressor.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import UIKit
import PhotosUI
import _PhotosUI_SwiftUI

struct PhotoConverter {
  
  static func convertUIImageToJpegData(image: UIImage, compressionQuality: CGFloat) -> Data? {
    return image.jpegData(compressionQuality: compressionQuality)
  }
  
  static func loadImageData(from item: PhotosPickerItem) async -> (UIImage?, Data?) {
    let imageData = try? await item.loadTransferable(type: Data.self)
    return (UIImage(data: imageData ?? Data()), imageData)
  }
  
  static func getImageData(fromPhotosPickerItem item: PhotosPickerItem) async -> Data? {
    return try? await item.loadTransferable(type: Data.self)
  }
}



