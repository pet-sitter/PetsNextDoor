//
//  MainTabs.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 8/29/24.
//

import SwiftUI


struct MainTabs: View {
  
  @Binding var selectedTab: MainTab
  
  private let imageSize: CGFloat = 32
  
  var body: some View {
    HStack(spacing: 0) {
      
      Spacer()
      
      Button {
        selectedTab = .home
      } label: {
        MainTab
          .home
          .image(isSelected: selectedTab == .home)
          .frame(width: imageSize, height: imageSize)
      }
      
      Spacer().frame(width: CGFloat(38))
      
      Button {
        selectedTab = .chatList
      } label: {
        MainTab
          .chatList
          .image(isSelected: selectedTab == .chatList)
          .frame(width: imageSize, height: imageSize)
      }
      
      Spacer().frame(width: CGFloat(20))
      
      Button {
        selectedTab = .map
      } label: {
        MainTab
          .map
          .image(isSelected: false)
          .frame(width: CGFloat(66), height: CGFloat(66))
          .offset(y: -15)
      }
      
      Spacer().frame(width: CGFloat(20))
      
      Button {
        selectedTab = .community
      } label: {
        MainTab
          .community
          .image(isSelected: selectedTab == .community)
          .frame(width: imageSize, height: imageSize)
      }
      
      Spacer().frame(width: CGFloat(38))
      
      Button {
        selectedTab = .myPage
      } label: {
        MainTab
          .myPage
          .image(isSelected: selectedTab == .myPage)
          .frame(width: imageSize, height: imageSize)
      }
      
      Spacer()
      
    }
    .background(PND.DS.gray20)
  }
  
  enum MainTab: CaseIterable {
    
    case home
    case chatList
    case map
    case community
    case myPage
    
    func image(isSelected: Bool) -> Image {
      switch self {
      case .home:
        Image(isSelected ? .iconHomeSelected : .iconHome)
          .resizable()
        
      case .chatList:
        Image(isSelected ? .iconChatSelected : .iconChat)
          .resizable()
        
      case .map:
        Image(.mapTab)
          .resizable()
        
      case .community:
        Image(isSelected ? .iconCommunitySelected : .iconCommunity)
          .resizable()
        
      case .myPage:
        Image(isSelected ? .iconUserSelected : .iconUser)
          .resizable()
      }
    }
  }
}

