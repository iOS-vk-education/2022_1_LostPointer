import UIKit

struct AlbumModel: Codable {
    let id: Int?
    let title, artwork, artworkColor: String?

    enum CodingKeys: String, CodingKey {
        case id, title, artwork
        case artworkColor = "artwork_color"
    }

    static func getHomeAlbums(onSuccess: @escaping ([AlbumModel]) -> Void, onError: @escaping(Error) -> Void) {
        Request.fetch(url: "/home/albums", method: RequestMethods.GET) {data in
            guard let
                    albums = try? JSONDecoder().decode([AlbumModel].self, from: data) else {
                        print("Error unmarshaling Albums data")
                        return
                    }
                onSuccess(albums)
        } onError: {err in
            onError(err)
        }
    }
}
