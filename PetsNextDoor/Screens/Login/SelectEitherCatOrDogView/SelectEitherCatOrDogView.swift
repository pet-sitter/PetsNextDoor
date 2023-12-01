//
//  SelectEitherCatOrDogView.swift
//  PetsNextDoor
//
//  Created by Kevin Kim on 11/29/23.
//

import SwiftUI

struct SelectEitherCatOrDogViewModel: HashableViewModel {
	
	var onPetSelection: ((PND.PetType) -> Void)?
	var selectedPetType: PND.PetType? = nil

}

struct SelectEitherCatOrDogView: View {
	
	@State var viewModel: SelectEitherCatOrDogViewModel
	
	var body: some View {
		HStack(alignment: .center) {
			
			Rectangle()
			.foregroundColor(.clear)
			.background(Color(red: 0.95, green: 0.95, blue: 0.95))
			.cornerRadius(4)
			.overlay {
				Image(viewModel.selectedPetType == .cat ? "add_cat_selected" : "add_cat_unselected")
					.resizable()
					.scaledToFit()
			}
			.overlay {
				Text("고양이")
					.fontWeight(.bold)
					.padding(.top, -64)
					.padding(.leading, -70)
			}
			.onTapGesture {
				viewModel.selectedPetType = .cat
				viewModel.onPetSelection?(.cat)
			}
			
			Spacer()
			
			Rectangle()
			.foregroundColor(.clear)
			.background(Color(red: 0.95, green: 0.95, blue: 0.95))
			.cornerRadius(4)
			.overlay {
				Image(viewModel.selectedPetType == .dog ? "add_dog_selected" : "add_dog_unselected")
				.resizable()
				.scaledToFit()
			}
			.overlay {
				Text("강아지")
					.fontWeight(.bold)
					.padding(.top, -64)
					.padding(.leading, -70)
			}
			.onTapGesture {
				viewModel.selectedPetType = .dog
				viewModel.onPetSelection?(.dog)
			}
		}
		.frame(height: 160)
		.padding()
	}
}


//#Preview {
//	SelectEitherCatOrDogView(viewModel: .init())
//}
