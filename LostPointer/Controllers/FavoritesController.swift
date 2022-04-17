import UIKit

class FavoritesController: UIViewController {
    var albumsCollectionView: UICollectionView?

    var albums: [AlbumModel] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        AlbumModel.getHomeAlbums(onSuccess: {(loadedAlbums: [AlbumModel]) -> Void in
            self.albums = loadedAlbums

            self.view.backgroundColor = UIColor(named: "backgroundColor")

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
            layout.itemSize = CGSize(width: 230, height: 380)
            layout.scrollDirection = .horizontal

            self.albumsCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
            self.albumsCollectionView?.heightAnchor.constraint(equalToConstant: self.view.frame.height / 2).isActive = true
            self.albumsCollectionView?.register(AlbumCell.self, forCellWithReuseIdentifier: "AlbumCell")
            self.albumsCollectionView?.backgroundColor = UIColor.black

            self.albumsCollectionView?.dataSource = self
            self.albumsCollectionView?.delegate = self

            self.view.addSubview(self.albumsCollectionView ?? UICollectionView())
        }, onError: {(err: Error) -> Void in
            print(err)
        })

    }
}

extension FavoritesController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // swiftlint:disable force_cast
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        albumCell.album = albums[indexPath.item]
        return albumCell
    }
}

extension FavoritesController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
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
