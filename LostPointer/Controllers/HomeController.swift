import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()

    var tracks: [TrackModel] = []
//    var artists: [ArtistModel] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsTableViewCell", for: indexPath) as! AlbumsTableViewCell
            return cell
        } else {
            // swiftlint:disable force_cast
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackTableViewCell", for: indexPath) as! TrackTableViewCell
            cell.track = tracks[indexPath.row - 1]
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 480
        } else {
            return 80
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TrackModel.getHomeTracks(onSuccess: {(loadedTracks: [TrackModel]) -> Void in
            self.tracks = loadedTracks

            self.view.addSubview(self.tableView)

            self.view.backgroundColor = UIColor(named: "backgroundColor")

            self.tableView.translatesAutoresizingMaskIntoConstraints = false

            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true

            self.tableView.dataSource = self
            self.tableView.delegate = self

            self.tableView.register(AlbumsTableViewCell.self, forCellReuseIdentifier: "AlbumsTableViewCell")
            self.tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "TrackTableViewCell")
        }, onError: {(err: Error) -> Void in
            print(err)
        })
    }

}

class TrackTableViewCell: UITableViewCell {

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
                albumImageView.downloaded(from: "https://lostpointer.site/static/artworks/" + (album.artwork!) + "_128px.webp")
            }
            controlsImageView.image = UIImage(systemName: "play.fill")
        }
    }

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
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
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

    let controlsImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // without this your image will shrink and looks ugly
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(albumImageView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(artistNameLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(controlsImageView)

        albumImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        albumImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10).isActive = true
        albumImageView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        albumImageView.heightAnchor.constraint(equalToConstant: 70).isActive = true

        containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: 10).isActive = true
        containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 40).isActive = true

        titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, constant: -30).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor).isActive = true

        artistNameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true
        artistNameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor).isActive = true
        artistNameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor).isActive = true

        controlsImageView.widthAnchor.constraint(equalToConstant: 26).isActive = true
        controlsImageView.heightAnchor.constraint(equalToConstant: 26).isActive = true
        controlsImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
        controlsImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

class AlbumsTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var albumsCollectionView: UICollectionView?
    
    var albums: [AlbumModel] = []
    var loaded: Bool = false
    
    override func layoutSubviews() {
        if loaded {
            return
        }
        super.layoutSubviews()
        
        AlbumModel.getHomeAlbums(onSuccess: {(loadedAlbums: [AlbumModel]) -> Void in
            self.albums = loadedAlbums

            self.backgroundColor = UIColor(named: "backgroundColor")

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
            layout.itemSize = CGSize(width: 230, height: 380)
            layout.scrollDirection = .horizontal

            self.albumsCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
            self.albumsCollectionView?.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
            self.albumsCollectionView?.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
            self.albumsCollectionView?.backgroundColor = UIColor.black
            
            self.albumsCollectionView?.delegate = self
            self.albumsCollectionView?.dataSource = self

            self.addSubview(self.albumsCollectionView ?? UICollectionView())
            self.loaded = true
        }, onError: {(err: Error) -> Void in
            print(err)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        albumCell.album = albums[indexPath.item]
        return albumCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}


class AlbumCell: UICollectionViewCell {

    var album: AlbumModel? {
        didSet {
            guard let albumItem = album else {return}
            if let artwork = albumItem.artwork {
                albumImageView.downloaded(from: "https://lostpointer.site/static/artworks/" + (artwork) + "_384px.webp")
            }
        }
    }

    let albumImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(albumImageView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12

        albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        albumImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(codeer:) has not been implemented")
    }
}
