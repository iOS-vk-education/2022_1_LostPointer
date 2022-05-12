import UIKit

class TabController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.tintColor = UIColor(named: "AccentColor")
        delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let home = HomeController()
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

        let profile = ProfileController()
        profile.tabBarItem = UITabBarItem(title: "Profile",
                                          image: UIImage(systemName: "person.crop.circle"),
                                          selectedImage: UIImage(systemName: "person.crop.circle.fill"))

        self.viewControllers = [home, favorites, search, profile]
    }

    private func tabBarController(_ tabBarController: UITabBarController,
                                  shouldSelect viewController: UIViewController) {
        self.navigationController?.setViewControllers([viewController], animated: true)
    }
}
