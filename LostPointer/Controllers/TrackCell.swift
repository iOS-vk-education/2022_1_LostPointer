import UIKit

class TrackCell: UITableViewCell {

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
                albumImageView.downloaded(from: "https://lostpointer.site/static/artworks/" + (album.artwork ?? "") + "_128px.webp")
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
