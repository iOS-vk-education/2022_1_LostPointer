import UIKit

final class AlbumCollectionViewCell: UICollectionViewCell {
    static var identifier = "AlbumCollectionViewCell"

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
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.addSubview(albumImageView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12

        NSLayoutConstraint.activate([
            albumImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            albumImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            albumImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
