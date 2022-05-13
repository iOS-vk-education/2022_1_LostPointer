import UIKit
import AVFoundation

class AudioPlayer: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    var playingCell: TrackCell?

    func playTrack(cell: TrackCell) {
        if let track = cell.getTrack() {
            if let playing = playingCell?.track {
                if playing.id == track.id {
                    return toggle()
                } else {
                    if let cell = playingCell {
                        cell.setPlaying(playing: false)
                    }
                }
            }
        }
        guard let track = cell.track else { return }
        guard let url = URL(string: Constants.tracksPath + track.file) else { return }
        playingCell = cell
        if let player = audioPlayer {
            player.stop()
        }

        cell.setPlaying(playing: true)
        downloadFileFromURL(url: url)
    }

    func downloadFileFromURL(url: URL) {
        var downloadTask: URLSessionDownloadTask
        downloadTask = URLSession.shared.downloadTask(with: url) { [weak self] (url, _, _) in
            if let url = url {
                self?.play(url: url)
            } else {
                return
            }
        }
        downloadTask.resume()
    }
    func toggle() {
        if let cell = playingCell {
            if audioPlayer.isPlaying {
                audioPlayer.pause()
                cell.setPlaying(playing: false)
            } else {
                audioPlayer.play()
                cell.setPlaying(playing: true)
            }
        }
    }
    func play(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer.prepareToPlay()
            audioPlayer.volume = 1 // ???
            if audioPlayer.play() {
                if let playing = playingCell {
                    playing.setPlaying(playing: true)
                }
            }
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
