import UIKit
import AVKit
import WebKit

final class MainController: UIViewController {

    var player: AudioPlayer!
    var webView: WKWebView
    var wvCookies: [HTTPCookie] = []

    init(player: AudioPlayer) {
        self.player = player
        self.webView = WKWebView()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        guard let player = self.player else { return }
        UserModel.checkAuth {[weak self] in
            return self?.navigationController?.setViewControllers([TabController(player: player)], animated: false)
        } onError: {[weak self] _ in
            return self?.navigationController?.setViewControllers([SigninController(player: player)], animated: false)
        }
    }
}
