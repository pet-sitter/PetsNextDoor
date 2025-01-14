//
//  SelectAddressView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 11/7/24.
//
import SwiftUI
import ComposableArchitecture

@Reducer
struct SelectAddressFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    
    var eventUploadModel: PND.EventUploadModel
    
    var jibunAddress: String = ""
    var roadAddress: String = ""
  
  }
  
  enum Action: BindableAction {
    case pushToSelectAddressDetail(eventUploadModel: PND.EventUploadModel)
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State,Action> {
    BindingReducer()
    Reduce { state, action in
      
      switch action {
        
      case .binding(\.jibunAddress):
        state.eventUploadModel.eventAddress = state.roadAddress
        state.eventUploadModel.eventJibunAddress = state.jibunAddress
        return .send(.pushToSelectAddressDetail(eventUploadModel: state.eventUploadModel))
        
      case .binding(\.roadAddress):
        return .none
        
      default:
        return .none
      }
    }
  }
}

struct SelectAddressView: View {
  
  @State var store: StoreOf<SelectAddressFeature>
  
  var body: some View {
    VStack(spacing: 0) {
      
      Text("이벤트 장소를 입력해주세요")
        .fontWeight(.bold)
        .font(.system(size: 20))
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, PND.Metrics.defaultSpacing)
      
      Spacer().frame(height: 20)
  
      SelectAddressWebView(
        jibunAddress: $store.jibunAddress,
        roadAddress: $store.roadAddress
      )
      Spacer()
    }
    .navigationTitle("주소 검색")
  }
}

import WebKit


struct SelectAddressWebView: UIViewRepresentable {
  
  typealias UIViewType = WKWebView
  
  @Binding var jibunAddress: String
  @Binding var roadAddress: String
  
  func makeCoordinator() -> Coordinator {
    Coordinator(parent: self)
  }
  
  func makeUIView(context: Context) -> WKWebView {
    context.coordinator.webView
  }
  
  func updateUIView(_ uiView: WKWebView, context: Context) {
    
  }
  
  final class Coordinator: NSObject, ObservableObject, WKScriptMessageHandler {

    private(set) var webView: WKWebView!
    
    @Published var jibunAddress: String = ""
    @Published var roadAddress: String = ""
    
    let parent: SelectAddressWebView
    
    init(parent: SelectAddressWebView) {
      self.parent = parent
      super.init()
      
      let contentController = WKUserContentController()
      contentController.add(self, name: "callBackHandler")
      
      let configuration = WKWebViewConfiguration()
      configuration.userContentController = contentController
      
      // 웹킷 뷰 생성
      let webView = WKWebView(frame: .init(x: 0, y: 0, width: 100, height: 100), configuration: configuration)
      
      self.webView = webView
      
      if let url = URL(string: "https://pet-sitter.github.io/addressSearch/") {
        let request = URLRequest(url: url)
        webView.load(request)
      }
    }
    
    func userContentController(
      _ userContentController: WKUserContentController,
      didReceive message: WKScriptMessage
    ) {
      if let data = message.body as? [String: Any] {
       
        // 기본 주소
        if let address = data["address"] as? String {
        }
        
        // 지번 주소
        if let jibunAddress = data["jibunAddress"] as? String {
          self.parent.jibunAddress = jibunAddress
        }
        
        // 도로명 주소
        if let roadAddress = data["roadAddress"] as? String {
          self.parent.roadAddress = roadAddress
        }
      }
      webView.reload()
    }
    
  }
  
}



#Preview {
  SelectAddressView(store: .init(initialState: .init(eventUploadModel: .init()), reducer: { SelectAddressFeature() }))
}
