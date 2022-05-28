import UIKit

struct TrackModel: Codable {
    var id: Int?
    var title, genre: String?
    var number: Int?
    var listenCount: Int?
    var duration: Int?
    var album: AlbumModel?
    var artist: ArtistModel?
    var isInFavorites: Bool?
    var file: String

    enum CodingKeys: String, CodingKey {
        case id, title, genre, number, duration, album, artist, file
        case listenCount = "listen_count"
        case isInFavorites = "is_in_favorites"
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

    static func likeTrack(id: Int, onSucess: @escaping (MessageModel) -> Void, onError: @escaping (Error) -> Void) {
        Request.fetch(url: "/track/like/\(id)", method: RequestMethods.POST) {data in
            guard let tracks = try? JSONDecoder().decode(MessageModel.self, from: data) else {
                debugPrint(NSError(domain: "TrackModel",
                                   code: -1, userInfo: ["Error": "Error unmarshalling message data (like)"]))
                return
            }
            onSucess(tracks)
        } onError: {err in
            onError(err)
        }
    }

    static func dislikeTrack(id: Int, onSucess: @escaping (MessageModel) -> Void, onError: @escaping (Error) -> Void) {
        Request.fetch(url: "/track/like/\(id)", method: RequestMethods.DELETE) {data in
            guard let tracks = try? JSONDecoder().decode(MessageModel.self, from: data) else {
                debugPrint(NSError(domain: "TrackModel",
                                   code: -1, userInfo: ["Error": "Error unmarshalling message data (like)"]))
                return
            }
            onSucess(tracks)
        } onError: {err in
            onError(err)
        }
    }
}
