import UIKit

class MainController: UIViewController {
    
    private let model = MainModel()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.text = "Present"
        button.titleLabel?.textColor = .white
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(buttonTupped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(named: "backgroundColor")
        
        view.addSubview(titleLabel)
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let titleSize = titleLabel.sizeThatFits(view.bounds.size)
        
        titleLabel.frame = CGRect(
            origin: CGPoint(
                x: view.bounds.minX + (view.bounds.width - titleSize.width) / 2,
                y: view.bounds.midY - titleSize.height / 2
            ),
            size: titleSize
        )
        
        button.frame = CGRect(
            x: view.bounds.minX + 20,
            y: titleLabel.frame.maxY + 34,
            width: view.bounds.width - 40,
            height: 30
        )
    }
    
    @objc
    func buttonTupped() {
        navigationController?.pushViewController(MainController(), animated: true)
//        if let prevVC = presentingViewController {
//            dismiss(animated: true)
//        } else {
//            let vc = MainController()
//            present(vc, animated: true)
//        }
    }
}
