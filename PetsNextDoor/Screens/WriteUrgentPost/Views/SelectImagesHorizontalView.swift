//
//  SelectImagesHorizontalView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/11.
//

import SwiftUI
import UIKit
import PhotosUI

struct SelectImagesHorizontalView: View {
  
  let maxImagesCount: Int
  
  @Binding var selectedImageDatas: [Data]
  
  @State private var selectedImages: [UIImage] = []
  @State private var isLoadingImages: Bool = false
  @State private var selectedPhotoPickerItems: [PhotosPickerItem] = []
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        
        Spacer()
          .frame(width: PND.Metrics.defaultSpacing)
        
        PhotosPicker(
          selection: $selectedPhotoPickerItems,
          maxSelectionCount: maxImagesCount,
          matching: .images)
        {
          ZStack {
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 100, height: 100)
              .background(PND.Colors.gray10.asColor)
              .cornerRadius(4)
            
            VStack {
              Image(systemName: "photo")
                .foregroundColor(PND.Colors.commonBlack.asColor)
                .frame(width: 28, height: 28)
              
              Text("\($selectedImages.count)/\(maxImagesCount)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(PND.Colors.commonBlack.asColor)
            }
            
          }
        }
        
        ForEach(selectedImages.indices, id: \.self) { index in
          imageView(selectedImages[index], index: index)
            .onTapGesture {
              deleteImage(at: index)
            }
        }
        
        if isLoadingImages {
          Spacer()
            .frame(width: PND.Metrics.defaultSpacing)
          ProgressView()
        }
        
        Spacer()
          .frame(width: PND.Metrics.defaultSpacing)
      }
      .onChange(of: selectedPhotoPickerItems) { _ in
        Task { await convertImageDataToUIImage() }
      }
    }
  }

  func imageView(_ image: UIImage, index: Int) -> some View {
    return Rectangle()
      .foregroundColor(.clear)
      .frame(width: 100, height: 100)
      .background(
        Image(uiImage: image)
          .resizable()
          .aspectRatio(contentMode: .fill)
          .frame(width: 100, height: 100)
          .clipped()
      )
      .cornerRadius(4)
      .overlay {
        VStack {
          HStack {
            Spacer()
            ZStack {
              RoundedRectangle(cornerRadius: 0)
                .cornerRadius(4, corners: [.bottomLeft, .topRight])
                .frame(width: 16, height: 16)
                .padding()
              
              Image(systemName: "xmark")
                .foregroundColor(.white)
                .frame(width: 7, height: 7)
                .cornerRadius(4)
            }
            .frame(width: 16, height: 16)
          }
          Spacer()
        }
      }
  }
  
  @MainActor
  private func convertImageDataToUIImage() async {
    
    isLoadingImages = true
    
    var uiImages: [UIImage] = []
    var imageData: [Data]   = []
    
    selectedImages.removeAll()
    
    if selectedPhotoPickerItems.isEmpty == false {
      
      for eachItem in selectedPhotoPickerItems {
        let (uiImage, data) = await loadImageData(from: eachItem)
        guard let uiImage, let data else {
          isLoadingImages = false
          return
        }
        
        uiImages.append(uiImage)
        imageData.append(data)
      }

      selectedImages = uiImages
    }
    
    isLoadingImages = false
  }
  
  private func loadImageData(from item: PhotosPickerItem) async -> (UIImage?, Data?) {
    let imageData = try? await item.loadTransferable(type: Data.self)
    return (UIImage(data: imageData ?? Data()), imageData)
  }
  
  func deleteImage(at index: Int) {
    selectedImages.remove(at: index)
  }
}

//#Preview {
//  SelectImagesHorizontalView(viewModel: .init(maxImagesCount: 5))
//}
