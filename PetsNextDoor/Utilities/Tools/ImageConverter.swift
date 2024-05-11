//
//  ImageConverter.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/05/11.
//

import UIKit

struct ImageConverter {
  
  static func desaturateImageToBlackAndWhite(image: UIImage) -> UIImage? {
    
    guard let currentCGImage = image.cgImage else { return nil }
    let currentCIImage = CIImage(cgImage: currentCGImage)
    
    let filter = CIFilter(name: "CIColorMonochrome")
    filter?.setValue(currentCIImage, forKey: "inputImage")
    
    filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")
    
    filter?.setValue(1.0, forKey: "inputIntensity")
    guard let outputImage = filter?.outputImage else { return nil }
    
    let context = CIContext()
    
    if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
      let processedImage = UIImage(cgImage: cgimg)
      
      return processedImage
    } else {
      return nil
    }
  }
}
