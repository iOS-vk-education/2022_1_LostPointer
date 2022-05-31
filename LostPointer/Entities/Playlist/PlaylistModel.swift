import UIKit
import LPFramework

struct PlaylistsModel: Codable {
    var playlists: [PlaylistModel]
}

struct PlaylistModel: Codable {
    var id: Int?
    var title, artwork, artworkColor: String?
    var tracks: [TrackModel]?
    var isPublic: Bool?
    var isOwn: Bool?

    enum CodingKeys: String, CodingKey {
        case id, title, artwork, tracks
        case artworkColor = "artwork_color"
        case isPublic = "is_public"
        case isOwn = "is_own"
    }

    func isPublicPlaylist(playlist: PlaylistModel) -> Bool {
        return playlist.isPublic ?? false
    }

    static func getHomePublicPlaylists(onSuccess: @escaping ([PlaylistModel]) -> Void, onError: @escaping (Error) -> Void) {
        Request.fetch(url: "/playlists", method: RequestMethods.GET) {data in
            guard let playlists = try? JSONDecoder().decode(PlaylistsModel.self, from: data) else {
                debugPrint("Error unmarshaling playlists data")
                return
            }
            var result: [PlaylistModel] = []
            for case let playlist? in playlists.playlists where playlist.isPublic ?? false {
                result.append(playlist)
            }
            onSuccess(result)
        } onError: {err in
            onError(err)
        }
    }

    static func getPlaylist(id: Int, onSuccess: @escaping (PlaylistModel) -> Void, onError: @escaping (Error) -> Void) {
        Request.fetch(url: "/playlists/\(id)", method: RequestMethods.GET) {data in
            guard let playlist = try? JSONDecoder().decode(PlaylistModel.self, from: data) else {
                debugPrint("Error unmarshaling playlist data")
                return
            }
            onSuccess(playlist)
        } onError: {err in
            onError(err)
        }
    }
}
