import UIKit
import WebKit
import LPFramework

final class ProfileController: UIViewController {
    var player: AudioPlayer
    var webView: WKWebView

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
        self.view.addSubview(webView)

        guard let cookie = Request.getCookie().first else { return }
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        webView.load(URLRequest.init(url: URL(string: "\(Constants.baseUrl)/profile")!))
        view = webView
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
