//
//  MapView.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2024/02/19.
//

import SwiftUI
import ComposableArchitecture
import Kingfisher

@Reducer
struct MapFeature: Reducer {
  
  @ObservableState
  struct State: Equatable {
    var eventIndex: Int = 0
  }
  
  
  enum Action: RestrictiveAction, BindableAction {
    
    enum ViewAction: Equatable {
      
    }
    
    enum InternalAction: Equatable {
      
    }
    
    enum DelegateAction: Equatable {
      
    }
    
    case view(ViewAction)
    case delegate(DelegateAction)
    case `internal`(InternalAction)
    
    case binding(BindingAction<State>)
  }
  
  var body: some Reducer<State,Action> {
    BindingReducer()
    Reduce { state, action in
      return .none
    }
  }
  
}


import NMapsMap

struct NaverMap: UIViewRepresentable {
  
  typealias UIViewType = NMFNaverMapView
  
  func makeCoordinator() -> Coordinator {
    Coordinator()
  }
  
  func makeUIView(context: Context) -> NMFNaverMapView {
    context.coordinator.getNaverMapView()
  }
  
  func updateUIView(_ uiView: NMFNaverMapView, context: Context) {
    
  }
  
  class Coordinator: NSObject, ObservableObject, NMFMapViewCameraDelegate, NMFMapViewTouchDelegate, CLLocationManagerDelegate {
    
    @Published var coord: (Double, Double) = (0.0, 0.0)
    @Published var userLocation: (Double, Double) = (0.0, 0.0)
    
    
    var locationManager: CLLocationManager?
    let startInfoWindow = NMFInfoWindow()
    
    let view = NMFNaverMapView(frame: .zero)
    
    override init() {
      super.init()
      
      
      view.mapView.positionMode = .direction
      view.mapView.isNightModeEnabled = true
      
      view.mapView.zoomLevel = 15 // 기본 맵이 표시될때 줌 레벨
      view.mapView.minZoomLevel = 1 // 최소 줌 레벨
      view.mapView.maxZoomLevel = 17 // 최대 줌 레벨
      
      
      
      view.showCompass = true //  나침반 : 카메라의 회전 및 틸트 상태를 표현합니다. 탭하면 카메라의 헤딩과 틸트가 0으로 초기화됩니다. 헤딩과 틸트가 0이 되면 자동으로 사라집니다
      view.showScaleBar = true // 스케일 바 : 지도의 축척을 표현합니다. 지도를 조작하는 기능은 없습니다.
      
      view.mapView.addCameraDelegate(delegate: self)
      view.mapView.touchDelegate = self
      
    }
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
      // 카메라 이동이 시작되기 전 호출되는 함수
    }

 
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
      // 카메라의 위치가 변경되면 호출되는 함수
    }
    
    // MARK: - 위치 정보 동의 확인
    
    /*
     ContetView 에서 .onAppear 에서 위치 정보 제공을 동의 했는지 확인하는 함수를 호출한다.
     위치 정보 제공 동의 순서
     1. MapView에서 .onAppear에서 checkIfLocationServiceIsEnabled() 호출
     2. checkIfLocationServiceIsEnabled() 함수 안에서 locationServicesEnabled() 값이 true인지 체크
     3. true일 경우(동의한 경우), checkLocationAuthorization() 호출
     4. case .authorizedAlways(항상 허용), .authorizedWhenInUse(앱 사용중에만 허용) 일 경우에만 fetchUserLocation() 호출
     */
    
    func checkLocationAuthorization() {
      guard let locationManager = locationManager else { return }
      
      switch locationManager.authorizationStatus {
      case .notDetermined:
        locationManager.requestWhenInUseAuthorization()
      case .restricted:
        print("위치 정보 접근이 제한되었습니다.")
      case .denied:
        print("위치 정보 접근을 거절했습니다. 설정에 가서 변경하세요.")
      case .authorizedAlways, .authorizedWhenInUse:
        print("Success")
        
        coord = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
        userLocation = (Double(locationManager.location?.coordinate.latitude ?? 0.0), Double(locationManager.location?.coordinate.longitude ?? 0.0))
        
        fetchUserLocation()
        
      @unknown default:
        break
      }
    }
    
    func checkIfLocationServiceIsEnabled() {
      DispatchQueue.global().async {
        if CLLocationManager.locationServicesEnabled() {
          DispatchQueue.main.async {
            self.locationManager = CLLocationManager()
            self.locationManager!.delegate = self
            self.checkLocationAuthorization()
          }
        } else {
          print("Show an alert letting them know this is off and to go turn i on")
        }
      }
    }
    
    // MARK: - NMFMapView에서 제공하는 locationOverlay를 현재 위치로 설정
    func fetchUserLocation() {
      if let locationManager = locationManager {
        let lat = locationManager.location?.coordinate.latitude
        let lng = locationManager.location?.coordinate.longitude
        let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0), zoomTo: 15)
        cameraUpdate.animation = .easeIn
        cameraUpdate.animationDuration = 1
        
        let locationOverlay = view.mapView.locationOverlay
        locationOverlay.location = NMGLatLng(lat: lat ?? 0.0, lng: lng ?? 0.0)
        locationOverlay.hidden = false
        
        locationOverlay.icon = NMFOverlayImage(name: "location_overlay_icon")
        locationOverlay.iconWidth = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.iconHeight = CGFloat(NMF_LOCATION_OVERLAY_SIZE_AUTO)
        locationOverlay.anchor = CGPoint(x: 0.5, y: 1)
        
        view.mapView.moveCamera(cameraUpdate)
      }
    }
    
    func getNaverMapView() -> NMFNaverMapView {
      view
    }
    
    // 마커 부분의 lat lng를 init 부분에 호출해서 사용하면 바로 사용가능하지만
    
    func setMarker(lat : Double, lng:Double) {
      let marker = NMFMarker()
      marker.iconImage = NMF_MARKER_IMAGE_PINK
      marker.position = NMGLatLng(lat: lat, lng: lng)
      marker.mapView = view.mapView
      
      let infoWindow = NMFInfoWindow()
      let dataSource = NMFInfoWindowDefaultTextSource.data()
      dataSource.title = "서울특별시청"
      infoWindow.dataSource = dataSource
      infoWindow.open(with: marker)
    }
  }
  
}



struct MapView: View {
  
  let store: StoreOf<MapFeature>
  
  @State var pageIndex: Int = 0
  
  var body: some View {
    VStack(spacing: 0) {
      topNavigationBar
      
      NaverMap()
        .onAppear() {
          
        }
        .overlay(alignment: .top, content: {
          Button {
            
          } label : {
            Capsule()
              .foregroundStyle(PND.DS.gray90)
              .frame(width: UIScreen.fixedScreenSize.width / 2, height: 36)
              .overlay(
                Text("+ 근처 이벤트 45개 더보기")
                  .multilineTextAlignment(.center)
                  .font(.system(size: 14, weight: .semibold))
                  .foregroundStyle(.white)
              )
          }
          .offset(y: 10)
          .buttonStyle(ScaleEffectButtonStyle())
        })
        .overlay(alignment: .bottom) {
          eventHorizontalTabView
        }
      
      Spacer()
    }
  }
  
  @ViewBuilder
  private var eventHorizontalTabView: some View {
    VStack(spacing: 0) {
      ScrollView(.horizontal, showsIndicators: false) {
        LazyHStack {
          
          DefaultSpacer(axis: .horizontal)
          
          ForEach(0..<10, id: \.self) { index in
            VStack(spacing: 0) {
              
              HStack(spacing: 0) {
                KFImage.url(MockDataProvider.randomePetImageUrl)
                  .resizable()
                  .scaledToFit()
                  .frame(width: 88, height: 88)
                  .clipShape(RoundedRectangle(cornerRadius: CGFloat(4)))
                
                Spacer().frame(width: CGFloat(8))
                
                VStack(alignment: .leading, spacing: 0) {
                  // 이벤트명
                  Text("이벤트 이름")
                    .lineLimit(2)
                    .font(.system(size: CGFloat(14), weight: .bold))
                  
                  Spacer().frame(height: CGFloat(5))
                  
                  // 위치
                  HStack(spacing: 4) {
                    Image(.iconPin)
                      .renderingMode(.template)
                      .resizable()
                      .frame(width: 16, height: 16)
                      .foregroundStyle(PND.DS.gray50)
                    
                    Text("서울 강서구")
                      .lineLimit(1)
                      .font(.system(size: CGFloat(12), weight: .medium))
                      .foregroundStyle(PND.DS.gray50)
                  }

                  Spacer().frame(height: CGFloat(10))
                  
                  // 참여 멤버 정보
                  HStack {
                    HStack(spacing: -4) {
                      ForEach(0..<3, id: \.self) { index in
                        
                        KFImage.url(MockDataProvider.randomePetImageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .clipShape(Circle())
                        .background(
                          Circle()
                            .fill(PND.DS.commonWhite)
                            .frame(width: 24, height: 24)
                        )
                      }
                    }

                    Text("5명 참여중")
                      .lineLimit(1)
                      .font(.system(size: CGFloat(12), weight: .medium))
                      .foregroundStyle(PND.DS.commonBlack)
                  }
                }
                
                Spacer()
              }
              
              Spacer().frame(height: CGFloat(8))
              
              // 상세 정보 더보기
              Button {
                
              } label: {
                RoundedRectangle(cornerRadius: 4)
                  .frame(height: 32)
                  .foregroundStyle(PND.Colors.commonBlack.asColor)
                  .overlay(
                    Text("상세 정보 더보기")
                      .font(.system(size: CGFloat(14), weight: .bold))
                      .foregroundStyle(.white)
                  )
                  .frame(height: CGFloat(32))
              }
              .buttonStyle(ScaleEffectButtonStyle())

            }
            .padding(.horizontal, CGFloat(20))
            .padding(.vertical, CGFloat(16))
            .frame(
              width: UIScreen.fixedScreenSize.width - 24 - 64
            )
            .background(
              PND.DS.commonWhite
            )
            .background(
              RoundedRectangle(cornerRadius: CGFloat(10))
                .strokeBorder(.gray, lineWidth: 1)
            )
          }
        }
        .scrollTargetLayout()

        
      }
      .frame(height: 160)
      .scrollTargetBehavior(.viewAligned)
      .background(Color.clear)

      Spacer().frame(height: 31)
    }
    .background(Color.clear)
  }
  
  
  @ViewBuilder
  private var topNavigationBar: some View {
    VStack(spacing: 0) {
      
      HStack {
        DefaultSpacer(axis: .horizontal)
        Text("지도")
          .font(.system(size: 20, weight: .bold))
        
        Spacer()
      }
      
      Spacer().frame(height: 9)
      
      
      RoundedRectangle(cornerRadius: 4)
        .frame(height: 40)
        .padding(.horizontal, PND.Metrics.defaultSpacing)
        .foregroundStyle(PND.DS.gray20)
        .overlay(alignment: .leading) {
          HStack(spacing: 8) {
            Image(.iconSearch)
              .size(16)
            
            Text("놀이이벤트를 검색해보세요")
              .foregroundStyle(UIColor(hex: "#9E9E9E").asColor)
              .font(.system(size: 16))
          }
          .padding(.leading, PND.Metrics.defaultSpacing + 12)
        }
      
      Spacer().frame(height: 15)
    }
  }
}

#Preview {
  MapView(store: .init(initialState: .init(), reducer: { MapFeature() }))
}
