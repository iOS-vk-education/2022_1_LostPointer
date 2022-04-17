import UIKit

class HomeController: UIViewController, UITableViewDataSource {
    private lazy var tableView: UITableView = {
        let table = UITableView()
        return table
    }()
    
    var activityIndicator = UIActivityIndicatorView(style: .large)
    var tracks: [TrackModel] = []
    var artists: [ArtistModel] = []
    var albums: [AlbumModel] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell",
                                                     for: indexPath) as! TrackTableViewCell
            cell.track = tracks[indexPath.row]
            return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(tableView)
        
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
        
        tableView.register(TrackTableViewCell.self,
                               forCellReuseIdentifier: "TableViewCell")
        tableView.dataSource = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.sizeThatFits(view.bounds.size)
        tableView.frame = CGRect(
            x: view.bounds.minX + 5,
            y: view.bounds.minY + 5,
            width: view.bounds.width - 10,
            height: view.bounds.height - 10
        )
        
    }
}


class TrackTableViewCell: UITableViewCell {
    let albumImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 35
        img.clipsToBounds = true
        return img
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        label.layer.cornerRadius = 5
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    // в примере тут флаги справа, но у нас будут контролы play/pause
    let controlsImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 13
        img.clipsToBounds = true
        return img
    }()
    
    var track: TrackModel? {
        didSet {
            guard let trackItem = track else {return}
            if let title = trackItem.title {
                titleLabel.text = title
            }
            if let artistName = trackItem.artist?.name {
                artistNameLabel.text = artistName
            }
            if let album = trackItem.album {
                albumImageView.image = UIImage(named: album.artwork!)
            }
            controlsImageView.image = UIImage(systemName: "play.fill")
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(albumImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(artistNameLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(controlsImageView)
        
        albumImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        albumImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant:70).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant:70).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.albumImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        artistNameLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo:self.titleLabel.bottomAnchor).isActive = true
        
        controlsImageView.widthAnchor.constraint(equalToConstant:26).isActive = true
        controlsImageView.heightAnchor.constraint(equalToConstant:26).isActive = true
        controlsImageView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-20).isActive = true
        controlsImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
