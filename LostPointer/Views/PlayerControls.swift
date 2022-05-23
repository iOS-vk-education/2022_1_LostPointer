import UIKit

class PlayerControls: UIView {
    private lazy var prevTrack: UIImageView = {
        let prev = UIImageView()
        prev.setBackgroundImage(img: UIImage(systemName: "house")!)
        return prev
    }()

    private lazy var play: UIImageView = {
        let prev = UIImageView()
        prev.setBackgroundImage(img: UIImage(systemName: "house")!)
        return prev
    }()

    private lazy var nextTrack: UIImageView = {
        let prev = UIImageView()
        prev.setBackgroundImage(img: UIImage(systemName: "house")!)
        return prev
    }()

    func setupView() {
        prevTrack.frame = CGRect(x: 0, y: 0,
                                 width: 10, height: 10)
        play.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        self.addSubview(prevTrack)
        self.addSubview(play)
        self.addSubview(nextTrack)
    }
}
