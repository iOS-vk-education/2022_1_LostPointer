import UIKit

class MainController: UIViewController {
    
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
        return input
    }()
    
    private lazy var signinButton: UIButton = {
        let button = UIButton(type: UIButton.ButtonType.roundedRect)
        button.titleLabel?.text = "Present"
        button.titleLabel?.textColor = .white
        button.backgroundColor = .blue
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
        let signinButtonSize = signinButton.sizeThatFits(view.bounds.size)
        
        loginInput.frame = CGRect(
        
                x: view.bounds.minX + 20,
                y: view.bounds.midY - inputSize.height / 2,
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
        user.authenticate()
    }
}
