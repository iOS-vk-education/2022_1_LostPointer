import UIKit

struct TrackModel: Codable {
    var id: Int?
    var title, genre: String?
    var number: Int?
    var listenCount: Int?
    var duration: Int?
    var album: AlbumModel?
    var artist: ArtistModel?
    var is_in_favorites: Bool?
    var file: String

    enum CodingKeys: String, CodingKey {
        case id, title, genre, number, duration, album, artist, is_in_favorites, file
        case listenCount = "listen_count"
    }

    static func getHomeTracks(onSuccess: @escaping ([TrackModel]) -> Void, onError: @escaping  (Error) -> Void) {
        Request.fetch(url: "/home/tracks", method: RequestMethods.GET) {data in
            guard let tracks = try? JSONDecoder().decode([TrackModel].self, from: data) else {
                debugPrint(NSError(domain: "TrackModel",
                                   code: -1, userInfo: ["Error": "Error unmarshaling tracks data (home)"]))
                return
            }
            onSuccess(tracks)
        } onError: {err in
            onError(err)
        }
    }

    static func getFavoritesTrack(onSucess: @escaping ([TrackModel]) -> Void, onError: @escaping (Error) -> Void) {
        Request.fetch(url: "/track/favorites", method: RequestMethods.GET) {data in
            guard let tracks = try? JSONDecoder().decode([TrackModel].self, from: data) else {
                debugPrint(NSError(domain: "TrackModel",
                                   code: -1, userInfo: ["Error": "Error unmarshalling tracks data (favorites)"]))
                return
            }
            onSucess(tracks)
        } onError: {err in
            onError(err)
        }
    }
}
