import UIKit

class AlbumCell: UICollectionViewCell {
    static var identifier = "AlbumCell"

    var album: AlbumModel? {
        didSet {
            guard let albumItem = album else {return}
            if let artwork = albumItem.artwork {
                albumImageView.downloaded(from: Constants.albumArtworkPrefix +
                                            artwork + Constants.albumArtworkMediumSuffix)
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
        fatalError("init(coder:) has not been implemented")
    }
}
