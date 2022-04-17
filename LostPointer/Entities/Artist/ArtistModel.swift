import UIKit

struct ArtistModel: Codable {
    let id: Int
    let name: String
    let avatar: String?
    
    static func getHomeArtists(onSuccess: @escaping ([ArtistModel])->Void, onError: @escaping  (Error)->Void) {
        var artists: [ArtistModel] = []
        Request.fetch(url: "/home/artists", method: RequestMethods.GET, successHandler: {(data: Data) -> Void in
            do {
                artists = try JSONDecoder().decode([ArtistModel].self, from: data)
                onSuccess(artists)
            }
            catch {
                print(error)
            }
        },errorHandler: {(err: Error) -> Void in
            onError(err)
        }
        )
    }
}

