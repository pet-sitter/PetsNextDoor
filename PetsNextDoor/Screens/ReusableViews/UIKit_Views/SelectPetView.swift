//
//  SelectPetView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/10/20.
//

import UIKit
import Combine
import SnapKit

final class SelectPetViewModel: HashableViewModel, ObservableObject {

  let id: Int
  @Published var petImageUrlString: String?
  @Published var petImageData: Data?
  @Published var petName: String
  @Published var petSpecies: String
  @Published var petAge: Int
  @Published var isPetNeutralized: Bool
  @Published var isPetSelected: Bool
  @Published var isDeleteButtonHidden: Bool
  
  @Published var gender: PND.Sex
  @Published var petType: PND.PetType
  @Published var birthday: String
  var weight: Int? = nil
  
  init(
    id: Int = UUID().hashValue,
    petImageUrlString: String? = nil,
    petImageData: Data? = nil,
    petName: String,
    petSpecies: String,
    petAge: Int,
    isPetNeutralized: Bool = false,
    isPetSelected: Bool = false,
    gender: PND.Sex,
    petType: PND.PetType,
    birthday: String,
    weight: Int? = nil,
    isDeleteButtonHidden: Bool = true
  ) {
    self.id = id
    self.petImageUrlString = petImageUrlString
    self.petImageData = petImageData
    self.petName = petName
    self.petSpecies = petSpecies
    self.petAge = petAge
    self.isPetNeutralized = isPetNeutralized
    self.isPetSelected = isPetSelected
    self.gender = gender
    self.petType = petType
    self.birthday = birthday
    self.weight = weight
    self.isDeleteButtonHidden = isDeleteButtonHidden
  }
}


import SwiftUI
import Kingfisher

struct SelectPetView: View {
  
  @StateObject var viewModel: SelectPetViewModel
  
  var onDeleteButtonTapped: (() -> Void)?
  
  init(
    viewModel: SelectPetViewModel,
    onDeleteButtonTapped: (() -> Void)?
  ) {
    self._viewModel = StateObject(wrappedValue: viewModel)
    self.onDeleteButtonTapped = onDeleteButtonTapped
  }
  
  
  var body: some View {
    VStack {
      HStack(alignment: .center, spacing: 17) {
        
        if let petImageUrl = viewModel.petImageUrlString {          
          KFImage(URL(string: petImageUrl))
            .placeholder {
              ProgressView()
            }
            .resizable()
            .frame(width: 74, height: 74)
            .clipShape(Circle())
            .scaledToFill()
        }
        
        if let localPetImageData = viewModel.petImageData, let image = UIImage(data: localPetImageData) {
          Image(uiImage: image)
            .resizable()
            .scaledToFill()
            .frame(width: 74, height: 74)
            .clipShape(Circle())
        }
        
        VStack(alignment: .leading, spacing: 4) {
          
          HStack {
            Text(viewModel.petName)
              .font(.system(size: 16, weight: .bold))
            
            Spacer()
            
            if viewModel.isDeleteButtonHidden == false  {
              Button {
                onDeleteButtonTapped?()
              } label: {
                Image(systemName: "xmark")
                  .foregroundColor(PND.Colors.commonGrey.asColor)
              }
            }
          }
          
          HStack(spacing: 4) {
            Text(viewModel.petSpecies)
              .font(.system(size: 14))
            
            Text("|")
              .font(.system(size: 14))
            
            Text("\(viewModel.petAge)살")
              .font(.system(size: 14))
          }
          
          Text(viewModel.isPetNeutralized ? "중성화 O" : "중성화 X")
            .padding(4)
            .lineLimit(1)
            .frame(height: 22)
            .background(PND.Colors.lightGreen.asColor)
            .cornerRadius(4)
            .foregroundColor(PND.Colors.primary.asColor)
            .font(.system(size: 12, weight: .bold))
          
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 13)
    }
    .contentShape(Rectangle())
    .background(
      RoundedRectangle(cornerRadius: 10)
        .strokeBorder(
          viewModel.isPetSelected
          ? PND.Colors.primary.asColor
          : PND.Colors.commonGrey.asColor,
          lineWidth: 1
        )
        .clipped()
    )
    .padding()
    .frame(height: 100)
  }
}
// 100 / 16
