import UIKit

struct AlbumModel: Codable {
    let id: Int
    let title, artwork, artworkColor: String

    enum CodingKeys: String, CodingKey {
        case id, title, artwork
        case artworkColor = "artwork_color"
    }
}
