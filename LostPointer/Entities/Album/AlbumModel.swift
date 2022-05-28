import UIKit

struct AlbumModel: Codable {
    var id, year, tracksDuration: Int?
    var title, artwork, artworkColor: String?

    enum CodingKeys: String, CodingKey {
        case id, year, title, artwork
        case artworkColor = "artwork_color"
        case tracksDuration = "tracks_duration"
    }

    static func getHomeAlbums(onSuccess: @escaping ([AlbumModel]) -> Void, onError: @escaping(Error) -> Void) {
        Request.fetch(url: "/home/albums", method: RequestMethods.GET) {data in
            guard let
                    albums = try? JSONDecoder().decode([AlbumModel].self, from: data) else {
                debugPrint("Error unmarshaling Albums data")
                return
            }
            onSuccess(albums)
        } onError: {err in
            onError(err)
        }
    }
}
