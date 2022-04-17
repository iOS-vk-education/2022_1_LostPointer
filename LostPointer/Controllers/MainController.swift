import UIKit

class MainController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")

        UserModel.checkAuth {
            return self.navigationController?.setViewControllers([TabController()], animated: false)
        } onError: {
            return self.navigationController?.setViewControllers([SigninController()], animated: false)
        }

    }

}
