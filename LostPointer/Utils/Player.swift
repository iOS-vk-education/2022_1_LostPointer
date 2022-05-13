import UIKit
import AVFoundation

class AudioPlayer: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!

    func downloadFileFromURL(url: URL) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { (url, _, _) in
            self.play(url: url!)
        }
        downloadTask.resume()
    }
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1
            audioPlayer.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
