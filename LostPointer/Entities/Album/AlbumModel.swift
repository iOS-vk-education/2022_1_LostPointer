import UIKit

struct AlbumModel: Codable {
    let id: Int?
    let title, artwork, artworkColor: String?

    enum CodingKeys: String, CodingKey {
        case id, title, artwork
        case artworkColor = "artwork_color"
    }
    
    static func getHomeAlbums(onSuccess: @escaping ([AlbumModel]) -> Void, onError: @escaping(Error) -> Void) {
        var albums: [AlbumModel] = []
        
        Request.fetch(url: "/home/albums", method: RequestMethods.GET, successHandler: {(data: Data) -> Void in
            do {
                albums = try JSONDecoder().decode([AlbumModel].self, from: data)
                onSuccess(albums)
            } catch {
                print(error)
            }
        }, errorHandler: {(err: Error) -> Void in
            onError(err)
        })
    }
}
