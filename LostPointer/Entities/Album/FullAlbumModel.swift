import UIKit

struct FullAlbumModel: Codable {
    var id, year, tracksDuration: Int?
    var title, artwork, artworkColor: String?
    var artist: ArtistModel?
    var tracks: [TrackModel]?

    enum CodingKeys: String, CodingKey {
        case id, year, title, artwork, artist, tracks
        case artworkColor = "artwork_color"
        case tracksDuration = "tracks_duration"
    }

    static func getAlbum(id: Int, onSuccess: @escaping (FullAlbumModel) -> Void, onError: @escaping  (Error) -> Void) {
        Request.fetch(url: "/album/\(id)", method: RequestMethods.GET) {data in
            guard let album = try? JSONDecoder().decode(FullAlbumModel.self, from: data) else {
                debugPrint("Error unmarshaling Album data")
                return
            }
            onSuccess(album)
        } onError: {err in
            onError(err)
        }
    }
}
