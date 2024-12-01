import Foundation

final class NotificationViewModel: ObservableObject {
    @Published var pendingFollowRequests: [MolioFollower] = [
        MolioFollower(id: UUID().uuidString, name: "김철수", description: "클래식 음악과 재즈를 사랑하는 사람입니다.", state: false),
        MolioFollower(id: UUID().uuidString, name: "이영희", description: "인디 아티스트이자 싱어송라이터입니다.", state: false),
        MolioFollower(id: UUID().uuidString, name: "박민준", description: "DJ와 일렉트로닉 음악 프로듀서입니다.", state: true),
        MolioFollower(id: UUID().uuidString, name: "최은지", description: "록 밴드 기타리스트입니다.", state: true),
        MolioFollower(id: UUID().uuidString, name: "정수현", description: "영화 사운드트랙 제작을 즐깁니다.", state: false),
        MolioFollower(id: UUID().uuidString, name: "한지민", description: "보컬 코치이자 합창단원입니다.", state: true),
        MolioFollower(id: UUID().uuidString, name: "윤재호", description: "K-POP 열성팬입니다.", state: false),
        MolioFollower(id: UUID().uuidString, name: "오서연", description: "힙합과 알앤비를 즐겨 듣는 음악 애호가입니다.", state: true),
        MolioFollower(id: UUID().uuidString, name: "배성훈", description: "피아노와 기타 연주를 좋아합니다.", state: false)
    ]
}