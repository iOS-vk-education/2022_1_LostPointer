import UIKit

final class TabController: UITabBarController, UITabBarControllerDelegate {

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
        home.tabBarItem = UITabBarItem(title: "Home",
                                       image: UIImage(systemName: "house"),
                                       selectedImage: UIImage(systemName: "house.fill"))

        let favorites = FavoritesController(player: self.player)
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

        let player = PlayerController(player: self.player)
        player.tabBarItem = UITabBarItem(title: "Now Playing",
                                         image: UIImage(systemName: "music.note"),
                                         tag: .max)

        self.viewControllers = [home, favorites, player, search, profile ]
    }

    private func tabBarController(_ tabBarController: UITabBarController,
                                  shouldSelect viewController: UIViewController) {
        debugPrint("tabbarController called")
        self.navigationController?.setViewControllers([viewController], animated: true)
    }

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is TabBarCustomPresentable {
            return false
        }
        return true
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        debugPrint(item.tag)
        if item.tag == .max {
            let player = PlayerController(player: player)
            present(player, animated: true, completion: nil)
        }
    }
}
