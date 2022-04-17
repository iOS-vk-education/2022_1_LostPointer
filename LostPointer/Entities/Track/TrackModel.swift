import UIKit

struct TrackModel: Codable {
    let id: Int?
    let title, genre: String?
    let number: Int?
    let listenCount: Int?
    let duration: Int?
    let album: AlbumModel?
    let artist: ArtistModel?
    let file: String

    enum CodingKeys: String, CodingKey {
        case id, title, genre, number, duration, album, artist, file
        case listenCount = "listen_count"
    }

    static func getHomeTracks(onSuccess: @escaping ([TrackModel]) -> Void, onError: @escaping  (Error) -> Void) {
        var tracks: [TrackModel] = []
        Request.fetch(url: "/home/tracks", method: RequestMethods.GET, successHandler: {(data: Data) -> Void in
            do {
//                print(String(data: data, encoding: String.Encoding.utf8))
                tracks = try JSONDecoder().decode([TrackModel].self, from: data)
                onSuccess(tracks)
            } catch {
                print(error)
                print(NSError(domain: "TrackModel", code: -1, userInfo: ["Error": "Error unmarshaling tracks data"]))
            }
        },
        errorHandler: {(err: Error) -> Void in
            onError(err)
        }
        )
    }

}
