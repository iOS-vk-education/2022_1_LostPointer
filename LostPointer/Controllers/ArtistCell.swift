import UIKit

final class ArtistCell: UICollectionViewCell {
    static var identifier = "ArtistCell"

    var artist: ArtistModel? {
        didSet {
            guard let artistItem = artist else {return}
            if let avatar = artistItem.avatar {
                avatarImageView.downloaded(from: "https://lostpointer.site/static/artists/" + (avatar) + "_128px.webp")
            }
        }
    }

    let avatarImageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()

    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.addSubview(avatarImageView)
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 12

        avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        avatarImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        avatarImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
