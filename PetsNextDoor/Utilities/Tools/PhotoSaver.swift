//
//  PhotoSaver.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 8/25/24.
//

import Foundation
import UIKit

final class PhotoSaver {

  func save(
    for urlString: String,
    onCompletion: (() -> Void)?
  ) {
    guard let url = URL(string: urlString) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      guard let data = data else { return }
      DispatchQueue.main.async { 
        guard let uiImage = UIImage(data: data) else { return }
        
        UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
        onCompletion?()
      }
    }
    task.resume()
  }
}
