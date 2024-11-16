import Foundation
import CoreData

final class DefaultPlaylistRepository: PlaylistRepository {
    private let context: NSManagedObjectContext
    
    private let alertNotFoundPlaylist: String = "해당 플레이리스트를 못 찾았습니다."
    private let alertNotFoundMusicsinPlaylist: String = "플레이리스트에 음악이 없습니다."
    private let alertFailDeletePlaylist: String = "플레이리스트를 삭제할 수 없습니다"
    
    init() {
        context = PersistenceManager.shared.context
    }
    
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    func addMusic(isrc: String, to playlistName: String) {
        guard let playlist = fetchPlaylist(for: playlistName), var musics = playlist.musics else { return }
        
        musics.append(isrc)
        playlist.musics = musics
        saveContext()
    }
    
    func deleteMusic(isrc: String, in playlistName: String) {
        guard let playlist = fetchPlaylist(for: playlistName), var musics = playlist.musics else { return }

        musics.removeAll { $0 == isrc }
        playlist.musics = musics
        saveContext()
    }
    
    func moveMusic(isrc: String, in playlistName: String, fromIndex: Int, toIndex: Int) {
        guard let playlist = fetchPlaylist(for: playlistName),
              var musics = playlist.musics,
              musics.indices.contains(fromIndex),
              musics.indices.contains(toIndex) else { return }
        
        if musics[fromIndex] == isrc {
            let musicToMove = musics.remove(at: fromIndex)
            musics.insert(musicToMove, at: toIndex)
            
            playlist.musics = musics
            saveContext()
        }
    }
    
    func fetchMusics(in playlistName: String) -> [String]? {
        guard let playlist = fetchPlaylist(for: playlistName), let musics = playlist.musics else {
            showAlert(alertNotFoundMusicsinPlaylist)
            return nil
        }
        return musics
    }
    
    func fetchPlaylists() -> [String]? {
        let fetchRequest: NSFetchRequest<MolioPlaylist> = MolioPlaylist.fetchRequest()
        do {
            let playlists = try context.fetch(fetchRequest)
            return playlists.compactMap{ $0.name }
        } catch {
            print("Failed to fetch playlists: \(error)")
            return nil
        }
    }
    
    func saveNewPlaylist(_ playlistName: String) {
        let playlist = MolioPlaylist(context: context)
        
        playlist.id = UUID()
        playlist.name = playlistName
        playlist.filters = []
        playlist.createdAt = Date()
        playlist.musics = []
        
        saveContext()
    }
    
    func deletePlaylist(_ playlistName: String) {
        guard let playlist = fetchPlaylist(for: playlistName) else { return }
        
        context.delete(playlist)
        saveContext()
    }
    
    func fetchPlaylist(for name: String) -> MolioPlaylist? {
        let fetchRequest: NSFetchRequest<MolioPlaylist> = MolioPlaylist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let playlists = try context.fetch(fetchRequest)
            return playlists.first
        } catch {
            print("Failed to fetch playlist: \(error)")
            return nil
        }
    }
    
    // MARK: - Private Method
    
    /// 현재 데이터 저장하기
    private func saveContext() {
        if context.hasChanges{
            PersistenceManager.shared.saveContext()
        }
    }
    
    private func fetchPlaylist(id: UUID) -> MolioPlaylist? {
        let fetchRequest: NSFetchRequest<MolioPlaylist> = MolioPlaylist.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let playlists = try context.fetch(fetchRequest)
            return playlists.first
        } catch {
            showAlert(alertNotFoundPlaylist)
            return nil
        }
    }
    
    // TODO: 알림창 추가
    private func showAlert(_ context: String) {
        print(context)
    }
}
