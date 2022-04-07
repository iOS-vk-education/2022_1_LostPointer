import UIKit

class MainController: UIViewController {
    
    private lazy var loginInput: UITextField = {
        let input = UITextField()
        input.text = "TEST1"
        return input
    }()
    
    private lazy var passwordInput: UITextField = {
        let input = UITextField()
        
        input.text = "TEST2"
        return input
    }()
    
    private lazy var signinButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Login"
        button.backgroundColor = .white
        button.addTarget(self, action: #selector(signinTap), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(loginInput)
        view.addSubview(passwordInput)
        view.addSubview(signinButton)
    }
    
//    private func getTracks() {
//        Request.fetch(url: "/home/tracks", method: RequestMethods.GET, successHandler: {(data: Data) -> Void in
//            let decoder = JSONDecoder()
//            if let tracks = try? decoder.decode([TrackModel].self, from: data) {
//                print(tracks)
//            } else {
//                print("Fetch error")
//            }
//        }, errorHandler: nil)
//    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let inputSize = loginInput.sizeThatFits(view.bounds.size)
        let signinButtonSize = signinButton.sizeThatFits(view.bounds.size)
        
        loginInput.frame = CGRect(
            origin: CGPoint(
                x: view.bounds.midX + (view.bounds.width - inputSize.width) / 2,
                y: view.bounds.midY - inputSize.height / 2
            ),
            size: inputSize
        )
        passwordInput.frame = CGRect(
            origin: CGPoint(
                x: view.bounds.midX + (view.bounds.width - inputSize.width) / 2,
                y: view.bounds.midY - inputSize.height / 2 + 20
            ),
            size: CGSize(width: 800, height: 22)
        )
        
        signinButton.frame = CGRect(
            origin: CGPoint(x: view.bounds.minX + (view.bounds.width - inputSize.width) / 2,
                            y: view.bounds.midY - inputSize.height / 2 + 60),
            size: CGSize(width: 800, height: 22)
        )
    }
    
    @objc func signinTap() {
        let user = UserModel(email: loginInput.text ?? "", password: passwordInput.text ?? "")
        user.authenticate()
    }
}
