import UIKit
import AudioToolbox

class HomeAlbumsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var albumsCollectionView: UICollectionView?

    var player: AudioPlayer?
    var navigator: UINavigationController?

    var albums: [AlbumModel] = []
    var loaded: Bool = false

    func load(player: AudioPlayer, navigator: UINavigationController?) {
        if loaded {
            return
        }

        self.player = player
        self.navigator = navigator

        AlbumModel.getHomeAlbums {loadedAlbums in
            self.albums = loadedAlbums

            self.backgroundColor = UIColor(named: "backgroundColor")

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
            layout.itemSize = CGSize(width: 230, height: 380)
            layout.scrollDirection = .horizontal

            self.albumsCollectionView = UICollectionView(frame: self.frame, collectionViewLayout: layout)
            self.albumsCollectionView?.heightAnchor.constraint(equalToConstant: self.frame.height / 2).isActive = true
            self.albumsCollectionView?.register(HomeAlbumCollectionViewCell.self, forCellWithReuseIdentifier: "HomeAlbumCell")
            self.albumsCollectionView?.backgroundColor = UIColor.black

            self.albumsCollectionView?.delegate = self
            self.albumsCollectionView?.dataSource = self

            self.addSubview(self.albumsCollectionView ?? UICollectionView())
            self.loaded = true
        } onError: {err in
            debugPrint(err)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { 5 }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let albumCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "HomeAlbumCell", for: indexPath) as? HomeAlbumCollectionViewCell
        albumCell?.album = albums[indexPath.item]
        return albumCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let player = self.player {
            self.navigator?.pushViewController(AlbumController(player: player, id: self.albums[indexPath.row].id ?? 0), animated: true)
        }
    }
}
