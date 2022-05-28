import UIKit

struct ArtistModel: Codable {
    var id: Int?
    var name: String?
    var avatar: String?
    var tracks: [TrackModel]?
    var albums: [AlbumModel]?

    static func getHomeArtists(onSuccess: @escaping ([ArtistModel]) -> Void, onError: @escaping  (Error) -> Void) {
        Request.fetch(url: "/home/artists", method: RequestMethods.GET) {data in
            guard let artists = try? JSONDecoder().decode([ArtistModel].self, from: data) else {
                debugPrint("Error unmarshaling Artist data")
                return
            }
            onSuccess(artists)
        } onError: {err in
            onError(err)
        }
    }

    static func getArtist(id: Int, onSuccess: @escaping (ArtistModel) -> Void, onError: @escaping  (Error) -> Void) {
        Request.fetch(url: "/artist/\(id)", method: RequestMethods.GET) {data in
            guard let artist = try? JSONDecoder().decode(ArtistModel.self, from: data) else {
                debugPrint("Error unmarshaling Artist data")
                return
            }
            onSuccess(artist)
        } onError: {err in
            onError(err)
        }
    }
}
