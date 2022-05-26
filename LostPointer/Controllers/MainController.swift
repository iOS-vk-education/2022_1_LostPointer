import UIKit
import AVKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        UserModel.checkAuth {[weak self] in
            return self?.navigationController?.setViewControllers([TabController()], animated: false)
        } onError: {[weak self] _ in
            return self?.navigationController?.setViewControllers([SigninController()], animated: false)
        }
    }
}
