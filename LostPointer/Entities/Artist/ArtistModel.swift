import UIKit

struct ArtistModel: Codable {
    let id: Int?
    let name: String?
    let avatar: String?

    static func getHomeArtists(onSuccess: @escaping ([ArtistModel]) -> Void, onError: @escaping  (Error) -> Void) {
        var artists: [ArtistModel] = []
        Request.fetch(url: "/home/artists", method: RequestMethods.GET) {data in
            guard let artists = try? JSONDecoder().decode([ArtistModel].self, from: data) else {
                print("Error unmarshaling Artist data")
                return
            }
            onSuccess(artists)
        } errorHandler: {err in
            onError(err)
        }
    }
}
