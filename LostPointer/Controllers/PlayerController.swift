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

    private lazy var controls: PlayerControls = {
        return PlayerControls()
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
        //        view.backgroundColor = // UIColor(named: "backgroundColor")
        artwork.frame = CGRect(
            x: view.bounds.midX * 0.2,
            y: view.bounds.midY * 0.15,
            width: view.bounds.width * 0.8,
            height: view.bounds.width * 0.8
        )
        seekbar.frame = CGRect(
            x: view.bounds.midX * 0.1,
            y: view.bounds.midY,
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
        controls.frame = CGRect(
            x: view.bounds.midX * 0.25,
            y: totalTime.bounds.maxY + 30,
            width: view.bounds.width,
            height: 80
        )
        volume.frame = CGRect(
            x: view.bounds.midX * 0.25,
            y: view.bounds.maxY * 0.75,
            width: view.bounds.width * 0.75,
            height: 40
        )
        [artwork, seekbar, elapsedTime,
         totalTime, controls, volume].forEach {subview in
            view.addSubview(subview)
         }

    }

    @objc
    func sliderDidEndSliding() {
        zoomIn()
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
}
