//
//  ExpandableView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 10/24/24.
//

import SwiftUI

struct ExpandableView: View {
  
  @Binding var isExpanded: Bool
  
  var thumbnail: ThumbnailView
  var expanded: ExpandedView

  var body: some View {
    ZStack {
      if isExpanded {
        VStack {
          thumbnail
          expanded
        }
      } else {
        thumbnail
      }
    }
    .background(Color.gray.opacity(0.2))
    .onTapGesture {
      withAnimation (.spring(response: 0.5)){
        isExpanded.toggle()
      }
    }
  }
}

struct ExpandedView: View {
  var id = UUID()
  @ViewBuilder var content: any View
  
  var body: some View {
    ZStack {
      AnyView(content)
    }
  }
}

struct ThumbnailView: View, Identifiable {
  var id = UUID()
  @ViewBuilder var content: any View
  
  var body: some View {
    ZStack {
      AnyView(content)
    }
  }
}
struct ContentView: View {
  
  @State private var isExpanded: Bool = false
  
  var body: some View {
    
    ZStack {
      ScrollView {
        VStack(spacing: 15){
        
            ExpandableView(
              isExpanded: $isExpanded,
              thumbnail: ThumbnailView {
                
                VStack(alignment: .leading, spacing: 10) {
                  Text("The art of being an artist")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black)
                  
                  Text("Reading time: 3 mins")
                    .foregroundStyle(.black)
                }
                .padding()
                
              },
              expanded: ExpandedView {
                VStack(alignment: .leading, spacing: 12) {
                  Text("The art of being an artist")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.black)
                  
                  Text("Reading time: 3 mins")
                  
                    .foregroundStyle(.black)
                  
                  Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                    .foregroundStyle(.black)
                  
                  Spacer()
                }
                .padding()
              }
            )
          
          ExpandableView(
            isExpanded: .constant(false),
            thumbnail: ThumbnailView {
              
              VStack(alignment: .leading, spacing: 10) {
                Text("The art of being an artist")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .foregroundStyle(.black)
                
                Text("Reading time: 3 mins")
                  .foregroundStyle(.black)
              }
              .padding()
              
            },
            expanded: ExpandedView {
              VStack(alignment: .leading, spacing: 12) {
                Text("The art of being an artist")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .foregroundStyle(.black)
                
                Text("Reading time: 3 mins")
                
                  .foregroundStyle(.black)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                  .foregroundStyle(.black)
                
                Spacer()
              }
              .padding()
            }
          )
          
          ExpandableView(
            isExpanded: .constant(false),
            thumbnail: ThumbnailView {
              
              VStack(alignment: .leading, spacing: 10) {
                Text("The art of being an artist")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .foregroundStyle(.black)
                
                Text("Reading time: 3 mins")
                  .foregroundStyle(.black)
              }
              .padding()
              
            },
            expanded: ExpandedView {
              VStack(alignment: .leading, spacing: 12) {
                Text("The art of being an artist")
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .foregroundStyle(.black)
                
                Text("Reading time: 3 mins")
                
                  .foregroundStyle(.black)
                
                Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
                  .foregroundStyle(.black)
                
                Spacer()
              }
              .padding()
            }
          )
          
        }
      }
      .scrollIndicators(.never)
      .padding()
    }

    
  }
}


#Preview {
  ContentView()
}
