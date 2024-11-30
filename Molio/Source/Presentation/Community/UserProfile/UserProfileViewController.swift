import SwiftUI

final class UserProfileViewController: UIHostingController<UserProfileView> {
    private let viewModel: UserProfileViewModel
    private let followRelationViewModel: FollowRelationViewModel
    
    private let isMyProfile: Bool
    private let followRelation: FollowRelationType?
    private let friendUserID: String?
    
    // MARK: - Initializer
    
    init(viewModel: UserProfileViewModel, followRelationViewModel: FollowRelationViewModel, isMyProfile: Bool, followRelation: FollowRelationType?, friendUserID: String?) {
        self.viewModel = viewModel
        self.followRelationViewModel = followRelationViewModel
        self.isMyProfile = isMyProfile
        self.followRelation = followRelation
        self.friendUserID = friendUserID
        
        let userProfileView = UserProfileView(isMyProfile: isMyProfile, followRelationType: followRelation, viewModel: viewModel, friendUserID: friendUserID)
        super.init(rootView: userProfileView)
        
        rootView.didSettingButtonTapped = navigateToSettingViewController
        rootView.didFollowerButtonTapped = navigationToFollowerListView
        rootView.didFollowingButtonTapped = navigationToFollowingListView
        rootView.didFollowerButtonTapped = navigationToFollowerListView
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isMyProfile = false
        self.followRelation = nil
        self.friendUserID = nil
        
        // TODO: 의존성 관리 - DIContainer
        self.viewModel = UserProfileViewModel(
            fetchPlaylistUseCase: DefaultFetchPlaylistUseCase(
                playlistRepisitory: DefaultPlaylistRepository(
                    playlistService: FirestorePlaylistService(),
                    playlistStorage: CoreDataPlaylistStorage()
                ),
                musicKitService: DefaultMusicKitService(),
                currentUserIDUseCase: DefaultCurrentUserIdUseCase(
                    authService: DefaultFirebaseAuthService(),
                    usecase: DefaultManageAuthenticationUseCase(
                        authStateRepository: DefaultAuthStateRepository()
                    )
                )
            ),
            currentUserIdUseCase: DefaultCurrentUserIdUseCase(
                authService: DefaultFirebaseAuthService(),
                usecase: DefaultManageAuthenticationUseCase(
                    authStateRepository: DefaultAuthStateRepository()
                )
            ),
            followRelationUseCase: DefaultFollowRelationUseCase(
                service: FirebaseFollowRelationService(),
                authService: DefaultFirebaseAuthService(), userUseCase: DefaultUserUseCase(service: FirebaseUserService())
            ), userUseCase: DefaultUserUseCase(service: FirebaseUserService())
        )
        
        self.followRelationViewModel = FollowRelationViewModel(
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
    
    // MARK: - Life Cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Present Sheet or Navigation
    
    private func navigateToSettingViewController() {
        let settingsViewController = SettingViewController()
        navigationController?.pushViewController(settingsViewController, animated: true)
    }
    
    private func navigationToFollowingListView() {
       
        let followingListViewController = FollowRelationViewController(viewModel: followRelationViewModel, isMyProfile: true, followRelation: .following, friendUserID: nil)
        navigationController?.pushViewController(followingListViewController, animated: true)
    }
    
    private func navigationToFollowerListView() {
        let followerListViewController = FollowRelationViewController(viewModel: followRelationViewModel, isMyProfile: true, followRelation: .unfollowing, friendUserID: nil)
        navigationController?.pushViewController(followerListViewController, animated: true)
    }
    
    private func presentPlaylistList() {
        print("플레이리스트 목록 클릭 시 이동") // TODO: 플레이리스트 목록 뷰으로 이동하는 코드 추가
    }

}