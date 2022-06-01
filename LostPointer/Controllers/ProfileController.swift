import UIKit
import WebKit
import LPFramework

final class ProfileController: UIViewController, WKNavigationDelegate {
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

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        debugPrint("WebView")
        if let url = webView.url?.absoluteString {
            print("url = \(url)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)

        guard let cookie = Request.getCookie().first else { return }
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        webView.load(URLRequest.init(url: URL(string: "\(Constants.baseUrl)/profile")!))
        view = webView
        navigationController?.isNavigationBarHidden = false
        // Add observer
        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }

    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {

            if let path = (key as? URL)?.path {
                if path == "/" {
                    navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(SigninController(player: player), animated: false)
                }
            }
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
}
