import UIKit
import AVFoundation
import MediaPlayer

final class AudioPlayer: NSObject {

    var player: AVPlayer?
    var playerItem: AVPlayerItem?
    var playingCell: TrackCell?
    let mpic = MPNowPlayingInfoCenter.default()
    var nowPlayingInfo: [String: AnyObject]?
    let audioSession: AVAudioSession
    let commandCenter: MPRemoteCommandCenter
    let nowPlayingInfoCenter: MPNowPlayingInfoCenter
    let notificationCenter: NotificationCenter

    typealias LGAudioPlayerDependencies = (audioSession: AVAudioSession, commandCenter: MPRemoteCommandCenter, nowPlayingInfoCenter: MPNowPlayingInfoCenter, notificationCenter: NotificationCenter)

    init(dependencies: LGAudioPlayerDependencies) {
        print("init called")
        self.audioSession = dependencies.audioSession
        self.commandCenter = dependencies.commandCenter
        self.nowPlayingInfoCenter = dependencies.nowPlayingInfoCenter
        self.notificationCenter = dependencies.notificationCenter

        super.init()

        do {
            try self.audioSession.setCategory(AVAudioSession.Category.playback)
        } catch {
            debugPrint(error)
            return
        }
        do {
            try self.audioSession.setActive(true)
        } catch {
            debugPrint(error)
            return
        }

        self.configureCommandCenter()
    }

    private func setupCommandCenter() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [MPMediaItemPropertyTitle: "LostPointer"]
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.playCommand.isEnabled = true
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.playCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.player?.play()
            return .success
        }
        commandCenter.pauseCommand.addTarget { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.player?.pause()
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
        if let player = self.player {
            player.stop()
        } else {
            setupAVAudioSession()
            setupCommandCenter()
        }

        // Пока не работает...
        mpic.nowPlayingInfo = [MPMediaItemPropertyTitle: "track",
                               MPMediaItemPropertyArtist: "artist",
                               MPNowPlayingInfoPropertyPlaybackRate: 1,
                               MPNowPlayingInfoPropertyElapsedPlaybackTime: 10,
                               MPMediaItemPropertyPlaybackDuration: 30
        ]
        play(url: url)
        cell.setPlaying(playing: true)
    }

    func toggle() {
        if let cell = playingCell {
            guard let player = player else { return }
            if player.timeControlStatus == .playing {
                player.pause()
                cell.setPlaying(playing: false)
            } else {
                player.play()
                cell.setPlaying(playing: true)
            }
        }
    }
    func play(url: URL) {
        player = AVPlayer(url: url)
        player?.volume = 1
        player?.play()
        updateNowPlayingInfoForCurrentPlaybackItem()
        self.updateCommandCenter()
        debugPrint("playing")
    }

    func next() {
        debugPrint("Next track")
    }

    func prev() {
        debugPrint("Prev track")
    }

    private func setupAVAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
            debugPrint("AVAudioSession is Active and Category Playback is set")
            UIApplication.shared.beginReceivingRemoteControlEvents()
            setupCommandCenter()
        } catch {
            debugPrint("Error: \(error)")
        }
    }

    private func setNowPlaying() {
        debugPrint("Now playing set")
    }

    func updateCommandCenter() {
        self.commandCenter.previousTrackCommand.isEnabled = true
        self.commandCenter.nextTrackCommand.isEnabled = true
        debugPrint("updated command center")
    }

    func configureCommandCenter() {
        self.commandCenter.playCommand.addTarget(handler: { [weak self] _ -> MPRemoteCommandHandlerStatus in
            guard let player = self?.player else { return .commandFailed }
            player.play()
            return .success
        })

        self.commandCenter.pauseCommand.addTarget(handler: { [weak self] _ -> MPRemoteCommandHandlerStatus in
            guard let player = self?.player else { return .commandFailed }
            player.pause()
            return .success
        })

        self.commandCenter.nextTrackCommand.addTarget(handler: { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.next()
            return .success
        })

        self.commandCenter.previousTrackCommand.addTarget(handler: { [weak self] _ -> MPRemoteCommandHandlerStatus in
            self?.prev()
            return .success
        })
        debugPrint("command center configured")
    }

    func updateNowPlayingInfoForCurrentPlaybackItem() {
        guard let _ = self.player else {
            self.configureNowPlayingInfo(nil)
            return
        }

        let track = playingCell?.getTrack()
        var nowPlayingInfo = [MPMediaItemPropertyTitle: track?.title,
                              MPMediaItemPropertyAlbumTitle: track?.album?.title,
                              MPMediaItemPropertyArtist: track?.artist?.name,
                              MPMediaItemPropertyPlaybackDuration: track?.duration,
                              MPNowPlayingInfoPropertyPlaybackRate: NSNumber(value: 1.0 as Float)] as [String: Any]

        if let artwork = track?.album?.artwork {
            if let image = UIImage(named: artwork) {
                nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: image)
            } else {
                debugPrint("artwork error")
            }
        }

        print("Now playing updated with", nowPlayingInfo)
        self.configureNowPlayingInfo(nowPlayingInfo as [String: AnyObject]?)

        self.updateNowPlayingInfoElapsedTime()
    }

    func updateNowPlayingInfoElapsedTime() {
        guard var nowPlayingInfo = self.nowPlayingInfo, let audioPlayer = self.player else { return }

        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(audioPlayer.currentTime()) as AnyObject

        self.configureNowPlayingInfo(nowPlayingInfo)
    }

    func configureNowPlayingInfo(_ nowPlayingInfo: [String: AnyObject]?) {
        debugPrint("Config now playing info")
        self.nowPlayingInfoCenter.nowPlayingInfo = nowPlayingInfo
        self.nowPlayingInfo = nowPlayingInfo
    }

    var isPlaying: Bool {
        guard let player = player else { return false }
        debugPrint("Player is playing \(player.timeControlStatus == .playing)")
        return player.timeControlStatus == .playing
    }
}
