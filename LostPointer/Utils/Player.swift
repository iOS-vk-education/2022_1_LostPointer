import UIKit
import AVFoundation

class AudioPlayer: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    var playingTrack: TrackModel?

    func playTrack(track: TrackModel) {
        if let playing = playingTrack {
            print("playing ok")
            if track.id == playing.id {
                print("toggle pause")
                return toggle()
            }
        }
        print("playing nok")
        guard let url = URL(string: Constants.tracksPath + track.file) else { return }
        playingTrack = track
        downloadFileFromURL(url: url)
    }

    func downloadFileFromURL(url: URL) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (url, _, _) in
            self?.play(url: url!)
        }
        downloadTask.resume()
    }
    func toggle() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else { audioPlayer.play() }
    }
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1 // ???
            audioPlayer.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
