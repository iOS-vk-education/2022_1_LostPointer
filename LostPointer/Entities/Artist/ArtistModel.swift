import UIKit

struct ArtistModel: Codable {
    let id: Int?
    let name: String?
    let avatar: String?

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
}
