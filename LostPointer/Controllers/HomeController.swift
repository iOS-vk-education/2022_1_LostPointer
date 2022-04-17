import UIKit

class HomeController: UIViewController {
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var tracks: [TrackModel] = []
    var artists: [ArtistModel] = []
    var albums: [AlbumModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        // Spinner
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicator.startAnimating()
        
        TrackModel.getHomeTracks(onSuccess: {(loadedTracks: [TrackModel]) -> Void in
            self.tracks = loadedTracks
        }, onError: {(err: Error) -> Void in
            print(err)            
        })
        ArtistModel.getHomeArtists(onSuccess: {(loadedArtists: [ArtistModel]) -> Void in
            self.artists = loadedArtists
        }, onError: {(err: Error) -> Void in
            print(err)
        });
        AlbumModel.getHomeAlbums(onSuccess: {(loadedAlbums: [AlbumModel]) -> Void in
            self.albums = loadedAlbums
        }, onError: {(err: Error) -> Void in
            print(err)
        })
    }
}
