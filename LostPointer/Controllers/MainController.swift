import UIKit

class MainController: UIViewController {
    
    func showToast(controller: UIViewController, message : String, seconds: Double) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        alert.view.alpha = 0.6
        alert.view.layer.cornerRadius = 15

        controller.present(alert, animated: true)

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
        }
    }
    
    private lazy var loginInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Login"
        input.backgroundColor = .white
        return input
    }()
    
    private lazy var passwordInput: UITextField = {
        let input = UITextField()
        input.placeholder = "Password"
        input.backgroundColor = .white
        input.isSecureTextEntry = true
        return input
    }()
    
    private lazy var signinButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.setTitle("TEST", for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 10
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        var inputSize = loginInput.sizeThatFits(view.bounds.size)
        inputSize.width *= 2
        signinButton.sizeThatFits(view.bounds.size)
        
        loginInput.frame = CGRect(
                x: view.bounds.minX + 20,
                y: view.bounds.minY + view.bounds.midY / 2,
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
    }
    
    @objc func signinTap() {
        let user = UserModel(email: loginInput.text ?? "", password: passwordInput.text ?? "")
        user.authenticate(onSuccess:  { [self] in
            showToast(controller: self, message : "Login Successful!", seconds: 2.0)
        },
        onError: {[self] in
            showToast(controller: self, message : "Incorrect credentials!", seconds: 2.0)
        })
    }
}
