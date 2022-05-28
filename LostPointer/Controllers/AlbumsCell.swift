import UIKit

class AlbumsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var albumsCollectionView: UICollectionView?

    var player: AudioPlayer?
    var navigator: UINavigationController?

    var albums: [AlbumModel] = []
    var loaded: Bool = false

    func load(albums: [AlbumModel], player: AudioPlayer, navigator: UINavigationController?) {
        if loaded {
            return
        }

        self.albums = albums
        self.player = player
        self.navigator = navigator

        self.backgroundColor = UIColor(named: "backgroundColor")

        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(width: 130, height: 130)

        let pairs = Int(self.albums.count / 2) + self.albums.count % 2
        let height = 160 * pairs

        let frame = CGRect(
            x: (UIScreen.main.bounds.size.width - self.contentView.bounds.size.width) / 2,
            y: 0,
            width: self.contentView.bounds.size.width ,
            height: CGFloat(height)
        )

        self.albumsCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        self.albumsCollectionView?.heightAnchor.constraint(
            equalToConstant: self.frame.height ).isActive = true
        self.albumsCollectionView?.register(
            AlbumCell.self, forCellWithReuseIdentifier: AlbumCell.identifier)
        self.albumsCollectionView?.backgroundColor = UIColor.black

        self.albumsCollectionView?.delegate = self
        self.albumsCollectionView?.dataSource = self

        self.addSubview(self.albumsCollectionView ?? UICollectionView())
        self.loaded = true

    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int { self.albums.count }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCell
        albumCell?.album = self.albums[indexPath.item]
        return albumCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let player = self.player {
            self.navigator?.pushViewController(AlbumController(player: player, id: self.albums[indexPath.row].id ?? 0), animated: true)
        }
    }
}
