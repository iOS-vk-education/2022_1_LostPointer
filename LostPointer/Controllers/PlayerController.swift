import UIKit
import AVFAudio

protocol TabBarCustomPresentable {}
class PlayerController: UIViewController, TabBarCustomPresentable {
    var player: AudioPlayer
    init(player: AudioPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private lazy var artwork: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.shadowColor = UIColor.black.cgColor
        imgView.layer.shadowOpacity = 0.3
        imgView.layer.shadowOffset = .zero
        imgView.layer.shadowRadius = 10
        return imgView
    }()

    private lazy var trackTitle: UILabel = {
        let title = UILabel()
        guard let customFont = UIFont(name: "Montserrat-Bold", size: 24) else {
            fatalError("Failed to load font")
        }
        title.font = UIFontMetrics.default.scaledFont(for: customFont)
        title.text = "Последняя дискотека"
        title.textColor = .white
        title.textAlignment = .center

        return title
    }()

    private lazy var artist: UILabel = {
        let artist = UILabel()
        guard let customFont = UIFont(name: "Montserrat-Semibold", size: 16) else {
            fatalError("Failed to load font")
        }
        artist.font = UIFontMetrics.default.scaledFont(for: customFont)
        artist.text = "Монеточка"
        artist.textColor = .white
        artist.textAlignment = .center

        return artist
    }()

    private lazy var seekbar: UISlider = {
        let slider = UISlider()

        slider.addTarget(self, action: #selector(sliderDidEndSliding), for: [.touchUpInside, .touchUpOutside])
        slider.addTarget(self, action: #selector(sliderDidStartSliding), for: [.touchDown])
        return slider
    }()

    private lazy var elapsedTime: UILabel = {
        let label = UILabel()
        guard let customFont = UIFont(name: "Montserrat-Bold", size: 16) else {
            fatalError("Failed to load font")
        }
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.textColor = .white
        return label
    }()

    private lazy var totalTime: UILabel = {
        let label = UILabel()
        guard let customFont = UIFont(name: "Montserrat-Bold", size: 16) else {
            fatalError("Failed to load font")
        }
        label.font = UIFontMetrics.default.scaledFont(for: customFont)
        label.textColor = .white
        return label
    }()

    private lazy var prev: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "backward.fill")
        img.tintColor = .white
        return img
    }()

    private lazy var pause: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "\(player.isPlaying ? "pause" : "play").fill")
        img.tintColor = .white

        let tap = UITapGestureRecognizer(target: self, action: #selector(play))
        img.addGestureRecognizer(tap)
        img.isUserInteractionEnabled = true

        return img
    }()

    private lazy var nextTrack: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "forward.fill")
        img.tintColor = .white
        return img
    }()

    private lazy var volume: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 1
        slider.setValue(AVAudioSession.sharedInstance().outputVolume, animated: false)
        return slider
    }()

    //    override func viewDidLayoutSubviews() {
    //        debugPrint("layoutsub")
    //    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let track = player.playingCell?.track
        if let art = track?.album?.artwork {
            artwork.downloaded(from: "https://lostpointer.site/static/artworks/\(art)_512px.webp")
        }
        if let artworkColor = track?.album?.artworkColor {
            let color = UIColor(artworkColor)
            self.view.applyGradient(isVertical: true, colorArray: [color, .black])
            seekbar.minimumTrackTintColor = color
            volume.minimumTrackTintColor = color
        }

        if let time = track?.duration {
            totalTime.text = "\(time / 3600):\(time / 60):\(time % 60)"
        }

        trackTitle.text = track?.title
        artist.text = track?.artist?.name

        updatePlaying()

        artwork.frame = CGRect(
            x: view.bounds.midX * 0.2,
            y: view.bounds.midY * 0.15,
            width: view.bounds.width * 0.8,
            height: view.bounds.width * 0.8
        )
        trackTitle.frame = CGRect(x: view.bounds.minX,
                                  y: view.bounds.height / 2 - 10,
                                  width: view.bounds.width,
                                  height: 30)
        artist.frame = CGRect(
            x: view.bounds.minX,
            y: view.bounds.height / 2 + 20,
            width: view.bounds.width,
            height: 20
        )
        seekbar.frame = CGRect(
            x: view.bounds.midX * 0.1,
            y: artist.frame.maxY + 30,
            width: view.bounds.width * 0.9,
            height: 40
        )
        elapsedTime.frame = CGRect(
            x: seekbar.bounds.minX + 15,
            y: seekbar.frame.maxY,
            width: view.bounds.width - 20,
            height: 40
        )
        totalTime.frame = CGRect(
            x: seekbar.bounds.maxX - 15,
            y: seekbar.frame.maxY,
            width: seekbar.bounds.width - 20,
            height: 40
        )
        pause.frame = CGRect(
            x: view.bounds.midX - 25,
            y: totalTime.frame.maxY + 10,
            width: 50,
            height: 50
        )
        prev.frame = CGRect(
            x: pause.frame.minX - 100,
            y: totalTime.frame.maxY + 10,
            width: 70,
            height: 50
        )
        nextTrack.frame = CGRect(
            x: pause.frame.maxX + 30,
            y: totalTime.frame.maxY + 10,
            width: 70,
            height: 50
        )
        volume.frame = CGRect(
            x: view.bounds.midX * 0.25,
            y: view.bounds.maxY * 0.8,
            width: view.bounds.width * 0.75,
            height: 40
        )

        [artwork, trackTitle, artist, seekbar, elapsedTime,
         totalTime, prev, pause, nextTrack, volume].forEach {subview in
            view.addSubview(subview)
         }
    }

    @objc
    func play() {
        if player.isPlaying {
            player.player?.pause()
        } else {
            player.player?.play()
        }
        updatePlaying()
    }

    private func updatePlaying() {
        if player.isPlaying {
            zoom(out: false)
            pause.image = UIImage(systemName: "pause.fill")
        } else {
            zoom(out: true)
            pause.image = UIImage(systemName: "play.fill")
        }
    }

    // zoom in or zoom out
    private func zoom(out: Bool) {
        UIView.animate(withDuration: 0.3, delay: 0,
                       usingSpringWithDamping: 10, initialSpringVelocity: 10,
                       options: []) { [weak self] in
            self?.artwork.transform = out ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
        }
    }

    @objc
    func sliderDidStartSliding() {
        zoom(out: true)
    }

    @objc
    func sliderDidEndSliding() {
        if player.isPlaying {
            zoom(out: false)
        }
    }

    @objc
    func timeUpdated() {

    }
}
