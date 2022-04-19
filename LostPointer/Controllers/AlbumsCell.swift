import UIKit

class AlbumsCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    var albumsCollectionView: UICollectionView?
    
    var albums: [AlbumModel] = []
    var loaded: Bool = false
    
    func load() {
        if loaded {
            return
        }
        
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
        let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCell
        albumCell?.album = albums[indexPath.item]
        return albumCell ?? UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       print("User tapped on item \(indexPath.row)")
    }
}
