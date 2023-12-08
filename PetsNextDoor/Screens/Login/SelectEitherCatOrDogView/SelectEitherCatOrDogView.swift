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
        .foregroundColor(viewModel.selectedPetType == .cat ? PND.Colors.primary.asColor : .clear)
			.background(Color(red: 0.95, green: 0.95, blue: 0.95))
			.cornerRadius(4)
			.overlay {
				Image("selectCat")
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
        .foregroundColor(viewModel.selectedPetType == .dog ? PND.Colors.primary.asColor : .clear)
			.background(Color(red: 0.95, green: 0.95, blue: 0.95))
			.cornerRadius(4)
			.overlay {
				Image("selectDog")
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
