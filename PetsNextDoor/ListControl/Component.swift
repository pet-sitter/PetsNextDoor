//
//  Component.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/07/30.
//

import UIKit
import SnapKit
import Combine
import SwiftUI

protocol ContentViewCompatable {
}

extension UIView: ContentViewCompatable {}

protocol Component: AnyObject, IdentifierProvidable, ComponentBuildable {
	
	associatedtype ContentView: ContentViewCompatable
  associatedtype ViewModel: HashableViewModel
	
	var viewModel: ViewModel { get }
	
	func createContentView() -> ContentView
	
  func render(contentView: ContentView)
  
  /**
   Component의 Height를 반환한다.
   - 일반적으로 UITableView delegate 메서드 중 heightForRowAt 에서 값을 반환할 때 쓰이는 값이다.
   - 따로 정의하지 않으면 기본값으로 nil이 반환된다.
   */
  func contentHeight() -> CGFloat?
}

extension Component {
  
  func buildComponents() -> [any Component] {
    return [self]
  }
}

//MARK: - Default extension methods

extension Component {
  
  var identifier: String { Self.identifier }
  
  func contentHeight() -> CGFloat? { nil }
}




// TEST
 

import SwiftUI

struct UserCellViewModel: HashableViewModel {
  
}


final class UserCellComponent: Component {
  
  typealias ContentView = UIView
  typealias ViewModel   = UserCellViewModel

  var viewModel: UserCellViewModel
  
  init(viewModel: ViewModel) {
    self.viewModel = viewModel
  }

  @MainActor
  func createContentView() -> ContentView {
    let config = UIHostingConfiguration { UserCell() }
    return config.makeContentView()
  }

  func render(contentView: ContentView) {
    
  }

  func contentHeight() -> CGFloat? {
    80
  }

}

struct UserCell: View {
  
  var body: some View {
    HStack {
      CircularProfileImageView()
      
      VStack(alignment: .leading) {
        Text("kevinkim256")
          .fontWeight(.semibold)
        
        Text("김영채")
          .font(.footnote)
        
      }
      .font(.footnote)
      
      
      Spacer()
        .foregroundColor(.blue)
      
      Text("Follow")
        .font(.subheadline)
        .fontWeight(.semibold)
        .frame(width: 100, height: 32)
        .overlay {
          RoundedRectangle(cornerRadius: 10)
            .stroke(Color(.systemGray4), lineWidth: 1)
        }
    }
    .padding(.horizontal)

  }
}





struct CircularProfileImageView: View {
  var body: some View {
    Image(systemName: "person.fill")
      .resizable()
      .scaledToFill()
      .frame(width: 40, height: 40)
      .clipShape(Circle())
  }
}
