//
//  MockDataProvider.swift
//  PetsNextDoor
//
//  Created by kevinkim2586 on 2023/12/30.
//

import Foundation

struct MockDataProvider {
  
  static var randomAuthorName: String {
    [
      "아롱맘",
      "다롱이맘",
      "시바견 주인",
      "케빈킴",
      "Boris"
    ]
      .randomElement()!
  }
  
  static var randomCount: Int {
    [1, 32, 120, 4, 6, 21, 64, 2, 3, 100, 49].randomElement()!
  }
  
  static var randomChatMessage: String {
    [
      "오늘 말고 내일 오셔도 되는데 가능할까요??",
      "주의사항 알려드려요~ 밥은 하루에 3끼, 8시 12시 6시 이렇게 주시면 돼요",
      "강아지가 산책하는걸 엄청 좋아해요 ㅜㅜ",
      "고양이가 사람을 엄청 좋아하고 완전 개냥이입니다!!",
      "네!",
      "네네 다음 주 월요일 시작입니다! 괜찮을까요?",
      "좋아요~",
    ]
      .randomElement()!
  }
  
  static var randomPetImageUrlString: String {
    "https://placedog.net/200/200?random"
  }
  
  static var randomePetImageUrl: URL {
    URL(string: "https://placedog.net/200/200?random")!
  }
  
  static var selectPetCellViewModels: [SelectPetViewModel] {
    [
      .init(
        petImageUrlString: "https://placedog.net/200/200random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: "1",
        isDeleteButtonHidden: true
      ),
      .init(
        petImageUrlString: "https://placedog.net/200/200?random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: "1",
        isDeleteButtonHidden: true
      ),
      .init(
        petImageUrlString: "https://placedog.net/200/200?random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: "1",
        isDeleteButtonHidden: true
      ),
      .init(
        petImageUrlString: "https://placedog.net/200/200?random",
        petName: "아롱이",
        petSpecies: "비숑 프리제",
        petAge: 1,
        isPetNeutralized: false,
        isPetSelected: false,
        gender: .male,
        petType: .dog,
        birthday: "12/23",
        weight: "1",
        isDeleteButtonHidden: true
      ),
      
    ]
  }
	
	static var chatBubbleViewModels: [ChatTextBubbleViewModel] {
		return [
			ChatTextBubbleViewModel(body: "안녕하세요~ 멍멍 모임방에 오신 걸 환영합니다! \n공지사항을 꼭 읽어주세요!", isMyChat: true),
			ChatTextBubbleViewModel(body: "안녕하세요~ 잘 부탁드립니다!", isMyChat: false),
			ChatTextBubbleViewModel(body: "어서오세요~ 환영합니다!", isMyChat: true),
			ChatTextBubbleViewModel(body: "강아지 피부병 때문에 병원을 가봐야할 거 같은데ㅇㅇ역 근처 동물병원 추천 받을 수 있을까요?", isMyChat: true),
			ChatTextBubbleViewModel(body: "Grand Central Dispatch 에서 작업(work)이 queue에 들어오면 시스템이 스레드를 불러와 해당 work item을 수행합니다. concurrent queue 는 여러 work item 을 한 번에 처리할 수 있기 때문에, 모든 CPU 코어가 포화될 때까지 시스템은 여러 스레드를 불러옵니다.", isMyChat: false),
			ChatTextBubbleViewModel(body: "이때 아래 그림에서 볼 수 있듯이 어떤 이유로 스레드가 차단된 상태에서 concurrent queue 에서 수행해야 할 작업이 더 많은 경우, GCD는 나머지 작업 항목(work item)을 처리하기 위해 스레드를 더 많이 불러옵니다.", isMyChat: false),
			ChatTextBubbleViewModel(body: "첫째, 프로세스에 다른 스레드를 제공함으로써 각 코어는 언제든지 작업(work)을 실행 중인 스레드를 계속 갖고 있을 수 있습니다. 이를 통해 어플리케이션은 지속적인 수준의 동시성 (continuing level of concurrency) 을 제공합니다.", isMyChat: true),
			ChatTextBubbleViewModel(body: "게 스레드를 새로 생성하고 작업을 수행함으로써 생기는 이점도 있지만, 만약 block 되는 스레드가 많아지고, 남아 있는 작업들을 수행하기 위해 스레드가 계속 생성된다면 어떨까요? 여전", isMyChat: false),
			ChatTextBubbleViewModel(body: "Thread Explosion 은 데드락을 포함해 메모리 및 스케줄링 오버헤드 등의 여러 문제점을 야기합니다. 간단히 알아볼까요?", isMyChat: true),
			ChatTextBubbleViewModel(body: "스케줄링 오버헤드 — CPU 는 이전 스레드에서 새 스레드로 전환을 실행하기 위해 전체 스레드 컨텍스트 스위치 (f", isMyChat: true),		
			ChatTextBubbleViewModel(body: "어서오세요~ 환영합니다!", isMyChat: true),
			ChatTextBubbleViewModel(body: "어서오세요~ 환영합니다!", isMyChat: false),
			ChatTextBubbleViewModel(body: "어서오세요~ 환영합니다!", isMyChat: true),
			ChatTextBubbleViewModel(body: "어서오세요~ 환영합니다!", isMyChat: false),
		]
	}
	
  static var chatTypes: [ChatViewType] {
    var chatTypes: [ChatViewType] = []
    
    var previousChatBubbleVM: ChatTextBubbleViewModel? = nil
    
    chatBubbleViewModels
      .enumerated()
      .forEach { index, vm in
        chatTypes.append(ChatViewType.text(vm))
        
        if let previousChatBubbleVM {
          
          if previousChatBubbleVM.isMyChat == vm.isMyChat {
            chatTypes.append(ChatViewType.spacer(height: 4))
          } else {
            chatTypes.append(ChatViewType.spacer(height: 10))
          }
          
          
        } else { // 0번째 index
          
        }
        
        previousChatBubbleVM = vm

     
      }
    
    return chatTypes

  }

}
