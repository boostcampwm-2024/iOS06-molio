protocol MusicKitService {
    func getMusic(with isrc: String) async -> RandomMusic?
}