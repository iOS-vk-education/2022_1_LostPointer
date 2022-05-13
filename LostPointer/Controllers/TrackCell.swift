import UIKit

protocol TrackCellDelegate: AnyObject {
    func cellBtnTapped(tag: Int)
}
class TrackCell: UITableViewCell {
    var playing: Bool = false
    let btn: UIButton = {
        let btn = UIButton()
        return btn
    }()
    weak var delegate: TrackCellDelegate?
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
                albumImageView.downloaded(from: Constants.albumArtworkPrefix + (album.artwork ?? "") + Constants.albumArtworkSmallSuffix)
            }
            controlsImageView.image = UIImage(systemName: "\(playing ? "pause" : "play").fill")
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
        img.contentMode = .scaleAspectFill
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

        NSLayoutConstraint.activate([
            albumImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            albumImageView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            albumImageView.widthAnchor.constraint(equalToConstant: 70),
            albumImageView.heightAnchor.constraint(equalToConstant: 70),

            containerView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            containerView.leadingAnchor.constraint(equalTo: self.albumImageView.trailingAnchor, constant: 10),
            containerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
            containerView.heightAnchor.constraint(equalToConstant: 40),

            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            titleLabel.widthAnchor.constraint(equalTo: self.containerView.widthAnchor, constant: -30),
            titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),

            artistNameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            artistNameLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor),

            controlsImageView.widthAnchor.constraint(equalToConstant: 26),
            controlsImageView.heightAnchor.constraint(equalToConstant: 26),
            controlsImageView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20),
            controlsImageView.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBAction func btnCellTapped(_ sender: UIButton) {
        delegate?.cellBtnTapped(tag: sender.tag)
    }

    func togglePlaying() {
        playing = !playing
        controlsImageView.image = UIImage(systemName: "\(playing ? "pause" : "play").fill")
    }
}
