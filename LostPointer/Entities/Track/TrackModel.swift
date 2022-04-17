import UIKit

struct TrackModel: Codable {
    let id: Int?
    let title, genre: String?
    let number: Int?
    let listenCount: Int?
    let duration: Int?
    let album: AlbumModel?
    let artist: ArtistModel?

    enum CodingKeys: String, CodingKey {
        case id, title, genre, number
        case listenCount = "listen_count"
        case duration, album, artist
    }
    
}
