import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {

    var player: AudioPlayer!

    init (player: AudioPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.tintColor = UIColor(named: "AccentColor")
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let home = HomeController(player: self.player)
        // Иконки тут - https://developer.apple.com/sf-symbols/
        home.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"),
                                       selectedImage: UIImage(systemName: "house.fill"))

        let favorites = FavoritesController()
        favorites.tabBarItem = UITabBarItem(title: "Favorites",
                                            image: UIImage(systemName: "heart"),
                                            selectedImage: UIImage(systemName: "heart.fill"))

        let search = SearchController()
        search.tabBarItem = UITabBarItem(title: "Search",
                                         image: UIImage(systemName: "magnifyingglass.circle"),
                                         selectedImage: UIImage(systemName: "magnifyingglass.circle.fill"))

        let profile = ProfileController(player: self.player)
        profile.tabBarItem = UITabBarItem(title: "Profile",
                                          image: UIImage(systemName: "person.crop.circle"),
                                          selectedImage: UIImage(systemName: "person.crop.circle.fill"))
        let player = PlayerController()
        player.tabBarItem = UITabBarItem(title: "player", image: nil, tag: 1)

        self.viewControllers = [home, favorites, search, profile, player]
    }

    private func tabBarController(_ tabBarController: UITabBarController,
                                  shouldSelect viewController: UIViewController) {
        self.navigationController?.setViewControllers([viewController], animated: true)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is PlayerController {
            viewController.definesPresentationContext = true
            viewController.modalPresentationStyle = .fullScreen
            let vc = UINavigationController(rootViewController: viewController)
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
}
