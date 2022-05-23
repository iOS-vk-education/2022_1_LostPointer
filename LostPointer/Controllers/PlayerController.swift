import UIKit
import AVFAudio

class PlayerController: UIViewController {
    private lazy var artwork: UIImageView = {
        let imgView = UIImageView()
        imgView.downloaded(from: "https://lostpointer.site/static/artworks/4bd10604-27a8-45d6-a0b6-b7f07b8a0fc3_512px.webp")
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
        label.text = "0:00"
        label.textColor = .white
        return label
    }()

    private lazy var totalTime: UILabel = {
        let label = UILabel()
        label.text = "5:00"
        label.textColor = .white
        return label
    }()

    //    private lazy var controls: PlayerControls = {
    //        return PlayerControls()
    //    }()

    private lazy var prev: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "backward.fill")
        img.tintColor = .white
        return img
    }()

    private lazy var pause: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(systemName: "play.fill")
        //        UIImage(systemName: "pause.fill")
        img.tintColor = .white
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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.applyGradient(isVertical: true, colorArray: [UIColor("#CF1994"), .black])
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
        //        controls.frame = CGRect(
        //            x: view.bounds.midX * 0.25,
        //            y: totalTime.bounds.maxY + 30,
        //            width: view.bounds.width,
        //            height: 80
        //        )
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

    private func zoomOut() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: []) { [weak self] in
            self?.artwork.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }

    private func zoomIn() {
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 10, options: []) {[weak self] in
            self?.artwork.transform = .identity
        }
    }

    @objc
    func sliderDidStartSliding() {
        zoomOut()
    }

    @objc
    func sliderDidEndSliding() {
        zoomIn()
    }
}
