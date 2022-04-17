import UIKit

class ProfileController: UIViewController {
    private lazy var avatar: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 100
        image.clipsToBounds = true
        image.downloaded(from: "https://lostpointer.site/static/users/3f5819a4-ae2d-408b-9750-f103c5649972_500px.webp")
        return image
    }()
    
//    private lazy var nicknameLabel: UILabel = {
//        
//    }()
//    
//    private lazy var nicknameInput: UITextField = {
//        
//    }()
//    
//    private lazy var emailLabel: UILabel = {
//        
//    }()
//    
//    private lazy var emailInput: UITextField = {
//        
//    }()
//    
//    private lazy var oldPasswordLabel: UITextLabel = {
//        
//    }
//    
//    private lazy var oldPasswordInput: UITextInput = {
//        
//    }
//    
//    private lazy var newPasswordLabel: UILabel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "backgroundColor")
        view.addSubview(avatar)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        avatar.frame = CGRect(
            x: view.bounds.midX - 100,
            y: view.bounds.minY + view.bounds.midY / 4,
            width: 200,
            height: 200
        )
    }
}
