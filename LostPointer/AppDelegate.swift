import UIKit
import AVFoundation
import MediaPlayer

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var player: AudioPlayer!
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let audioSession = AVAudioSession.sharedInstance()
        let commandCenter = MPRemoteCommandCenter.shared()
        let nowPlayingInfoCenter = MPNowPlayingInfoCenter.default()
        let notificationCenter = NotificationCenter.default

        self.player = AudioPlayer(dependencies: (audioSession, commandCenter, nowPlayingInfoCenter, notificationCenter))

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: MainController(player: player))
        window?.makeKeyAndVisible()

        application.beginReceivingRemoteControlEvents()

        // Чтобы смотреть названия шрифтов, пока оставим
        //        for family in UIFont.familyNames.sorted() {
        //            let names = UIFont.fontNames(forFamilyName: family)
        //            debugPrint("Family: \(family) Font names: \(names)")
        //        }

        return true
    }
}
