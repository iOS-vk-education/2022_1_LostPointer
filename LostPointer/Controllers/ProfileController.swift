import UIKit

class ProfileController: UIViewController {
    private lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 100
        image.clipsToBounds = true
        image.downloaded(from: "https://lostpointer.site/static/users/3f5819a4-ae2d-408b-9750-f103c5649972_500px.webp")
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
        button.backgroundColor = UIColor(named: "accentColor")
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(avatar)
        view.addSubview(nicknameLabel)
        view.addSubview(nicknameInput)
        view.addSubview(emailLabel)
        view.addSubview(emailInput)
        view.addSubview(oldPasswordLabel)
        view.addSubview(oldPasswordInput)
        view.addSubview(newPasswordLabel)
        view.addSubview(newPasswordInput)
        view.addSubview(saveButton)
        view.addSubview(logoutButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatar.frame = CGRect(
            x: view.bounds.midX - 100,
            y: view.bounds.minY + view.bounds.midY / 4,
            width: 200,
            height: 200
        )
        
        nicknameLabel.frame = CGRect(
            x: view.bounds.minX + 10,
            y: avatar.frame.maxY + 30,
            width: view.bounds.width - 40,
            height: 15
        )
        nicknameInput.frame = CGRect(
            x: view.bounds.minX + 10,
            y: nicknameLabel.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 30
        )
        emailLabel.frame = CGRect(
            x: view.bounds.minX + 10,
            y: nicknameInput.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 15
        )
        emailInput.frame = CGRect(
            x: view.bounds.minX + 10,
            y: emailLabel.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 30
        )
        oldPasswordLabel.frame = CGRect(
            x: view.bounds.minX + 10,
            y: emailInput.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 15
        )
        oldPasswordInput.frame = CGRect(
            x: view.bounds.minX + 10,
            y: oldPasswordLabel.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 30
        )
        newPasswordLabel.frame = CGRect(
            x: view.bounds.minX + 10,
            y: oldPasswordInput.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 15
        )
        newPasswordInput.frame = CGRect(
            x: view.bounds.minX + 10,
            y: newPasswordLabel.frame.maxY + 10,
            width: view.bounds.width - 40,
            height: 30
        )
        saveButton.frame = CGRect(
            x: view.bounds.minX + 10,
            y: newPasswordInput.frame.maxY + 10,
            width: view.bounds.width - 20,
            height: 40
        )
        logoutButton.frame = CGRect(
            x: view.bounds.minX + 10,
            y: saveButton.frame.maxY + 10,
            width: view.bounds.width - 20,
            height: 40
        )
    }
    
    @objc func saveProfile() {
//        UserModel.updateProfile();
    }
    
    @objc func logout() {
        UserModel.logout(onSuccess: {() -> Void in
            return (self.navigationController?.setViewControllers([SigninController()], animated: true))!
        }, onError: {(err: Error) -> Void in
            print(err)
        });
    }
}
