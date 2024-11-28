import FirebaseCore
import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let container = DIContainer.shared
        
        container.register(NetworkProvider.self, dependency: DefaultNetworkProvider())
        container.register(SpotifyTokenProvider.self, dependency: DefaultSpotifyTokenProvider())
        container.register(ImageFetchService.self, dependency: DefaultImageFetchService())
        container.register(SpotifyAPIService.self, dependency: MockSpotifyAPIService())
        container.register(MusicKitService.self, dependency: DefaultMusicKitService())
        container.register(AuthService.self, dependency: DefaultFirebaseAuthService())
        container.register(AuthLocalStorage.self, dependency: DefaultAuthLocalStorage())
        
        // Repository
        container.register(RecommendedMusicRepository.self, dependency: DefaultRecommendedMusicRepository())
        container.register(ImageRepository.self, dependency: DefaultImageRepository())
        container.register(CurrentPlaylistRepository.self, dependency: DefaultCurrentPlaylistRepository())
        container.register(PlaylistRepository.self, dependency: MockPlaylistRepository())
        container.register(SignAppleRepository.self, dependency: DefaultSignAppleRepository())
        container.register(AuthStateRepository.self, dependency: DefaultAuthStateRepository())
        
        // UseCase
        container.register(FetchRecommendedMusicUseCase.self, dependency: DefaultFetchRecommendedMusicUseCase())
        container.register(FetchImageUseCase.self, dependency: DefaultFetchImageUseCase())
        container.register(FetchAvailableGenresUseCase.self, dependency: DefaultFetchAvailableGenresUseCase())
        container.register(CreatePlaylistUseCase.self, dependency: DefaultCreatePlaylistUseCase())
        container.register(ChangeCurrentPlaylistUseCase.self, dependency: DefaultChangeCurrentPlaylistUseCase())
        container.register(PublishCurrentPlaylistUseCase.self, dependency: DefaultPublishCurrentPlaylistUseCase())
        container.register(PublishAllMusicInCurrentPlaylistUseCase.self, dependency: DefaultPublishAllMusicInCurrentPlaylistUseCase())
        container.register(UpdatePlaylistUseCase.self, dependency: DefaultUpdatePlaylistUseCase())
        container.register(AudioPlayer.self, dependency: SwipeMusicPlayer())
        container.register(SignInAppleUseCase.self, dependency: DefaultSignInAppleUseCase())
        container.register(ManageAuthenticationUseCase.self, dependency: DefaultManageAuthenticationUseCase())
        container.register(AddMusicToPlaylistUseCase.self, dependency: DefaultAddMusicToPlaylistUseCase())
        container.register(CheckAppleMusicSubscriptionUseCase.self, dependency: DefaultCheckAppleMusicSubscriptionUseCase())
        
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
}
