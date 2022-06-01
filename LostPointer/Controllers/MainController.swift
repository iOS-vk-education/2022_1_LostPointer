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

        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookies in
            HTTPCookieStorage.shared.setCookies(cookies, for: URL(string: "https://lostpointer.site/"), mainDocumentURL: URL(string: "https://lostpointer.site/"))
            for cookie in cookies {
                debugPrint("cookie", cookie)
                self?.wvCookies.append(cookie as HTTPCookie)
            }
        }
        //        debugPrint(HTTPCookieStorage.shared.getCookiesFor(URL(string: "https://lostpointer.site/")!), completionHandler: nil))
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
