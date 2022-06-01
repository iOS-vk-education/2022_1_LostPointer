import UIKit
import WebKit
import LPFramework

final class SigninController: UIViewController, WKNavigationDelegate {

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

    func showToast(controller: UIViewController, message: String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)

        alert.view.alpha = 0.2
        alert.view.layer.cornerRadius = 15
        alert.view.backgroundColor = .red

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {[weak alert] in
            alert?.dismiss(animated: true)
        }
    }

    private lazy var loginInput: UITextField = {
        let input = UITextField()
        input.attributedPlaceholder = NSAttributedString(
            string: "Login",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        input.backgroundColor = .white
        input.textColor = .black
        return input
    }()

    private lazy var passwordInput: UITextField = {
        let input = UITextField()
        input.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray]
        )
        input.backgroundColor = .white
        input.textColor = .black
        input.isSecureTextEntry = true
        return input
    }()

    private lazy var signinButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signinTap), for: .touchUpInside)
        return button
    }()

    private lazy var signupButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("Sign Up", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(signupTap), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        view.addSubview(loginInput)
        view.addSubview(passwordInput)
        view.addSubview(signinButton)
        view.addSubview(signupButton)

        webView.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var inputSize = loginInput.sizeThatFits(view.bounds.size)
        inputSize.width *= 2
        signinButton.sizeThatFits(view.bounds.size)

        loginInput.frame = CGRect(
            x: view.bounds.minX + 20,
            y: view.bounds.midY - view.bounds.midY / 4,
            width: view.bounds.width - 40,
            height: 30
        )
        passwordInput.frame = CGRect(
            x: view.bounds.minX + 20,
            y: loginInput.frame.maxY + 20,
            width: view.bounds.width - 40,
            height: 30
        )

        signinButton.frame = CGRect(
            x: view.bounds.minX + 20,
            y: passwordInput.frame.maxY + 34,
            width: view.bounds.width - 40,
            height: 30
        )

        signupButton.frame = CGRect(
            x: view.bounds.minX + 20,
            y: signinButton.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 30
        )
    }

    @objc func signinTap() {
        UserModel.authenticate(email: loginInput.text ?? "", password: passwordInput.text ?? "") {
            return self.navigationController?.setViewControllers([TabController(player: self.player)], animated: true)
        } onError: { err in
            self.showToast(controller: self, message: "Incorrect credentials!", seconds: 1.0)
            self.showAlert(title: "Error", message: err.localizedDescription)
            return nil
        }
    }

    @objc func signupTap() {
        //        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        webView.load(URLRequest.init(url: URL(string: "\(Constants.baseUrl)/signup")!))
        view = webView
    }

    func stopLoading() {
        webView.removeFromSuperview()
    }

    // Observe value
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if let key = change?[NSKeyValueChangeKey.newKey] {

            if let path = (key as? URL)?.path {
                if path == "/" {
                    webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { [weak self] cookies in
                        HTTPCookieStorage.shared.setCookies(cookies, for: URL(string: "https://lostpointer.site/"), mainDocumentURL: URL(string: "https://lostpointer.site/"))
                    }
                    navigationController?.isNavigationBarHidden = true
                    self.navigationController?.pushViewController(MainController(player: player), animated: false)
                }
            }
        }
    }
}
