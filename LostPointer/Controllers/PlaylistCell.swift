import UIKit
import LPFramework

final class PlaylistCell: UITableViewCell {
    var playlist: PlaylistModel? {
        didSet {
            guard let playlistItem = playlist else {return}
            if let title = playlistItem.title {
                titleLabel.text = title
            }
            playlistImageView.downloaded(from: Constants.baseUrl + (playlist?.artwork ?? ""))
        }
    }

    let playlistImageView: UIImageView = {
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
    let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(playlistImageView)
        containerView.addSubview(titleLabel)
        self.contentView.addSubview(containerView)

        NSLayoutConstraint.activate([
            playlistImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            playlistImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            playlistImageView.widthAnchor.constraint(equalToConstant: 70),
            playlistImageView.heightAnchor.constraint(equalToConstant: 70),

            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.playlistImageView.trailingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func getPlaylist() -> PlaylistModel? {
        guard let playlist = playlist else {
            return nil
        }
        return playlist
    }
}
