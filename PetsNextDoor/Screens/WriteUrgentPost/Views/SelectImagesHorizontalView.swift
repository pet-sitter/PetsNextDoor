//
//  SelectImagesHorizontalView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/11.
//

import SwiftUI
import UIKit
import PhotosUI

final class SelectImagesHorizontalViewModel: HashableViewModel, ObservableObject {
  
  var selectedImagesCount: Int = 0
  let maxImagesCount: Int
  
  private var selectedImagesData: [Data] = []
  @Published var selectedImages: [UIImage] = []
  @Published var selectedPhotoPickerItems: [PhotosPickerItem] = []
  
  var isLoadingImages: Bool = false
  
  init(maxImagesCount: Int) {
    self.maxImagesCount = maxImagesCount
  }
  
  @MainActor
  func convertImageDataToUIImage() async {
    
    isLoadingImages = true
    
    var uiImages: [UIImage] = []
    
    selectedImages.removeAll()
    
    if selectedPhotoPickerItems.isEmpty == false {
      
      for eachItem in selectedPhotoPickerItems {
        if let image = await loadImageData(from: eachItem) {
          uiImages.append(image)
        }
      }
      
      selectedImages = uiImages
      selectedImagesCount = selectedPhotoPickerItems.count
    }
    
    isLoadingImages = false
    
  }
  
  private func loadImageData(from item: PhotosPickerItem) async -> UIImage? {
    let imageData = try? await item.loadTransferable(type: Data.self)
    return UIImage(data: imageData ?? Data())
  }
  
  func deleteImage(at index: Int) {
    print("✅ delete images \(index)")
    selectedImages.remove(at: index)
    selectedPhotoPickerItems.remove(at: index)
  }
}

struct SelectImagesHorizontalView: View {
  
  @StateObject var viewModel: SelectImagesHorizontalViewModel
  
  var body: some View {
    ScrollView(.horizontal, showsIndicators: false) {
      HStack {
        
        Spacer()
          .frame(width: PND.Metrics.defaultSpacing)
        
        PhotosPicker(
          selection: $viewModel.selectedPhotoPickerItems,
          maxSelectionCount: viewModel.maxImagesCount,
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
                .foregroundColor(PND.Colors.primary.asColor)
                .frame(width: 28, height: 28)
              
              Text("\($viewModel.selectedPhotoPickerItems.count)/\(viewModel.maxImagesCount)")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(PND.Colors.commonBlack.asColor)
            }
            
          }
        }
        
        ForEach(viewModel.selectedImages.indices, id: \.self) { index in
          imageView(viewModel.selectedImages[index], index: index)
        }
        

        if viewModel.isLoadingImages {
          Spacer()
            .frame(width: PND.Metrics.defaultSpacing)
          ProgressView()
        }
        
        Spacer()
          .frame(width: PND.Metrics.defaultSpacing)
      }
      .onChange(of: viewModel.selectedPhotoPickerItems) { _ in
        Task { await viewModel.convertImageDataToUIImage() }
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
              
              Button {
                print("✅ button tapped")
                viewModel.deleteImage(at: index)
              } label: {
                Image(systemName: "xmark")
                  .foregroundColor(.white)
                  .frame(width: 10, height: 10)
                  .cornerRadius(4)
              }
            }
            .frame(width: 16, height: 16)
          }
          Spacer()
        }
      }
  }
}

//struct SelectImagesHorizontalView_Previews: PreviewProvider {
//  static var previews: some View {
//    SelectImagesHorizontalView(viewModel: .init(
//      maxImagesCount: 5)
//    )
//  }
//}
