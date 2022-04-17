import UIKit

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
