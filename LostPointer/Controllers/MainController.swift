import UIKit
import AVKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        UIApplication.shared.beginReceivingRemoteControlEvents() // ?
        view.backgroundColor = UIColor(named: "backgroundColor")
        UserModel.checkAuth {[weak self] in
            return self?.navigationController?.setViewControllers([TabController()], animated: false)
        } onError: {[weak self] _ in
            return self?.navigationController?.setViewControllers([SigninController()], animated: false)
        }
    }
}
