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

}
