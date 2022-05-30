import UIKit
import WebKit

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
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        return spinner
    }()

    private lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 90
        image.clipsToBounds = true
        return image
    }()

    private lazy var nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "Nickname"
        label.textColor = .white
        return label
    }()

    private lazy var nicknameInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Nickname"
        return input
    }()

    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        label.textColor = .white
        return label
    }()

    private lazy var emailInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Email"
        return input
    }()

    private lazy var oldPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Old password"
        label.textColor = .white
        return label
    }()

    private lazy var oldPasswordInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Old password"
        input.isSecureTextEntry = true
        return input
    }()

    private lazy var newPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "New password"
        label.textColor = .white
        return label
    }()

    private lazy var newPasswordInput: UITextField = {
        let input = UITextField()
        input.placeholder = "New password"
        input.isSecureTextEntry = true
        return input
    }()

    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm password"
        label.textColor = .white
        return label
    }()

    private lazy var confirmPasswordInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Confirm password"
        input.isSecureTextEntry = true
        return input
    }()

    private lazy var saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(saveProfile), for: .touchUpInside)
        return button
    }()

    private lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(named: "AccentColor")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()

    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ])

        scrollView.backgroundColor = UIColor(named: "backgroundColor")
        scrollView.superview?.isUserInteractionEnabled = true
        [
            saveButton, logoutButton].forEach {[weak self] view in
                self?.scrollView.addSubview(view)
            }

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(activityIndicator)

        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        activityIndicator.startAnimating()

        UserModel.getProfileData {[weak self] data in
            guard let profile = try? JSONDecoder().decode(UserModel.self, from: data) else {
                debugPrint("UserModel unmarshaling error")
                return
            }

            self?.avatar.downloaded(from: Constants.baseUrl + profile.bigAvatar!)
            self?.nicknameInput.text = profile.nickname
            self?.emailInput.text = profile.email

            self?.activityIndicator.stopAnimating()
        } onError: {[weak self] err in
            self?.activityIndicator.startAnimating()
            debugPrint(err)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        saveButton.frame = CGRect(
            x: scrollView.bounds.minX + 10,
            y: confirmPasswordInput.frame.maxY + 10,
            width: scrollView.bounds.width - 20,
            height: 40
        )
        logoutButton.frame = CGRect(
            x: scrollView.bounds.minX + 10,
            y: saveButton.frame.maxY + 10,
            width: scrollView.bounds.width - 20,
            height: 40
        )

        let contentRect: CGRect = scrollView.subviews.reduce(into: .zero) { rect, view in
            rect = rect.union(view.frame)
        }
        scrollView.contentSize = contentRect.size
    }

    @objc func saveProfile() {
        debugPrint("Open ВКИД)")
        guard let cookie = Request.getCookie().first else { return }
        webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        webView.load(URLRequest.init(url: URL(string: "\(Constants.baseUrl)/profile")!))
        view = webView
    }

    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void) {
        if navigationAction.navigationType == .other {
            if let redirectedUrl = navigationAction.request.url {
                debugPrint(redirectedUrl)
            }
            decisionHandler(.cancel)
            return
        }
        decisionHandler(.allow)
    }

    @objc func logout() {
        debugPrint("Logout")
        let alert = UIAlertController(title: "Log out", message: "Are you sure you want to log out?",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: {[weak self] _ in
            UserModel.logout {
                guard let player = self?.player else { return nil }
                return self?.navigationController?.setViewControllers([SigninController(player: player)], animated: true)
            } onError: {err in
                debugPrint(err)
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
