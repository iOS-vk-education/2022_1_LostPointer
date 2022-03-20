import UIKit

class TrackModel {
    var artwork: String
    var artist: ArtistModel
    var album: AlbumModel
    var duration: Int32
    
    init(artwork: String, artist: ArtistModel, album: AlbumModel, duration: Int32) {
        self.artwork = artwork
        self.artist = artist
        self.album = album
        self.duration = duration
    }
}
