import Combine
import Foundation

final class FriendPlaylistDetailViewModel: ObservableObject {
    @Published var friendPlaylist: MolioPlaylist?
    @Published var friendPlaylistMusics: [MolioMusic] = []
    @Published var selectedIndex: Int?
    
    private let fetchPlaylistUseCase: FetchPlaylistUseCase
    var exportFriendsMusicToMyPlaylistDelegate: ExportFriendsMusicToMyPlaylistDelegate?
        
    init(
        friendPlaylist: MolioPlaylist,
        fetchPlaylistUseCase: FetchPlaylistUseCase = DIContainer.shared.resolve()
    ) {
        self.friendPlaylist = friendPlaylist
        self.fetchPlaylistUseCase = fetchPlaylistUseCase
        self.fetchMusics(for: friendPlaylist)
    }
    
    private func fetchMusics(for playlist: MolioPlaylist) {
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                // MARK: 친구 아이디가 아닌 경우에도 필요하게 되었다. 임시로 ""로 처리한다. 없어도 된다

                // TODO: - 배포 때는 이 줄 바꾸기
                self.friendPlaylistMusics = try await self.fetchPlaylistUseCase
                    .fetchAllFriendMusics(
                        friendUserID: "",
                        playlistID: playlist.id
                    )
                debugPrint(self.friendPlaylistMusics)
            } catch {
                debugPrint(error)
            }
        }
    }
    
    func setDelegate(_ delegate: ExportFriendsMusicToMyPlaylistDelegate) {
        self.exportFriendsMusicToMyPlaylistDelegate = delegate
    }

    func exportFriendsMusicToMyPlaylist(molioMusic: MolioMusic) {
        exportFriendsMusicToMyPlaylistDelegate?.exportFriendsMusicToMyPlaylist(molioMusic: molioMusic)
    }
    
}
