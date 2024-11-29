import SwiftUI

final class FollowRelationViewController: UIHostingController<FollowRelationListView> {
    private let viewModel: FollowRelationViewModel
    private let isMyProfile: Bool
    private let followRelation: FollowRelationType
    private let friendUserID: String?
    
    // MARK: - Initializer
    
    init(viewModel: FollowRelationViewModel, isMyProfile:Bool, followRelation: FollowRelationType, friendUserID: String?) {
        self.viewModel = viewModel
        self.isMyProfile = isMyProfile
        self.followRelation = followRelation
        self.friendUserID = friendUserID
        
        let followRelationListView = FollowRelationListView(viewModel: viewModel, followRelationType: followRelation)
        super.init(rootView: followRelationListView)
        
    }
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        switch followRelation {
        case .unfollowing:
            navigationItem.title = "팔로워"
        case .following:
            navigationItem.title = "팔로잉"
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isMyProfile = false
        self.followRelation = .following
        self.friendUserID = nil
        
        // TODO: 의존성 관리 - DIContainer
        self.viewModel = FollowRelationViewModel(
            followRelationUseCase: DefaultFollowRelationUseCase(
                service: FirebaseFollowRelationService(),
                authService: DefaultFirebaseAuthService(),
                userUseCase: DefaultUserUseCase(
                    service: FirebaseUserService())
            ),
            userUseCase: DefaultUserUseCase(
                service: FirebaseUserService())
        )
        super.init(coder: aDecoder)
    }
    
    // MARK: - Present Sheet or Navigation
    
    private func navigateToSettingViewController() {
      
    }
}
