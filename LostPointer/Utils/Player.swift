import UIKit
import AVFoundation
import MediaPlayer

class AudioPlayer: UIViewController, AVAudioPlayerDelegate {

    var audioPlayer: AVAudioPlayer!
    var playingCell: TrackCell?
    let mpic = MPNowPlayingInfoCenter.default()

    func setupNowPlayingInfoCenter() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            print("Playback OK")
            try AVAudioSession.sharedInstance().setActive(true)
            print("Session is Active")
        } catch {
            print(error)
        }
        UIApplication.shared.beginReceivingRemoteControlEvents()
        print("setup")
        UIApplication.shared.beginReceivingRemoteControlEvents()
        MPRemoteCommandCenter.shared().playCommand.addTarget {[weak self] _ in
            self?.toggle()
            return .success
        }
        MPRemoteCommandCenter.shared().pauseCommand.addTarget {[weak self] _ in
            self?.toggle()
            return .success
        }
        MPRemoteCommandCenter.shared().nextTrackCommand.addTarget {_ in
            //          self.goForward()
            return .success
        }
        MPRemoteCommandCenter.shared().previousTrackCommand.addTarget {_ in
            //          self.goBackward()
            return .success
        }
    }

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
        } else {
            setupNowPlayingInfoCenter()
        }

                mpic.nowPlayingInfo = [MPMediaItemPropertyTitle: "track",
                                       MPMediaItemPropertyArtist: "artist",
                                       MPNowPlayingInfoPropertyPlaybackRate: 1,
                                       MPMediaItemPropertyArtwork: ,
                                       MPNowPlayingInfoPropertyElapsedPlaybackTime: 10,
                                       MPMediaItemPropertyPlaybackDuration: 30
                ]


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
            audioPlayer.play()
        } catch let error as NSError {
            print(error.localizedDescription)
        } catch {
            print("AVAudioPlayer init failed")
        }
    }
}
