import UIKit

class ArtistsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var artistsCollectionView: UICollectionView?

    var artists: [ArtistModel] = []
    var loaded: Bool = false

    func load() {
        if loaded {
            return
        }

        ArtistModel.getHomeArtists { [weak self] loadedArtists in
            self?.artists = loadedArtists

            self?.backgroundColor = UIColor(named: "backgroundColor")

            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
            layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            layout.itemSize = CGSize(width: 130, height: 130)

            let frame = CGRect(
                x: (UIScreen.main.bounds.size.width - (self?.contentView.bounds.size.width ?? 300)) / 2,
                y: 0,
                width: self?.contentView.bounds.size.width ?? 300,
                height: 290
            )

            self?.artistsCollectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
            self?.artistsCollectionView?.heightAnchor.constraint(equalToConstant: self?.frame.height ?? 0 / 2).isActive = true
            self?.artistsCollectionView?.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
            self?.artistsCollectionView?.backgroundColor = UIColor.black

            self?.artistsCollectionView?.register(ArtistCell.self, forCellWithReuseIdentifier: ArtistCell.identifier)
            self?.artistsCollectionView?.backgroundColor = UIColor.black

            self?.artistsCollectionView?.delegate = self
            self?.artistsCollectionView?.dataSource = self

            self?.addSubview(self?.artistsCollectionView ?? UICollectionView())
            self?.loaded = true
        } onError: {err in
            print(err)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let artistCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ArtistCell", for: indexPath) as? ArtistCell
        artistCell?.artist = artists[indexPath.item]
        return artistCell ?? UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
