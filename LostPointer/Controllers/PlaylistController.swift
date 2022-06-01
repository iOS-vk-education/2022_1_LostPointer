import UIKit

final class PlaylistController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let player: AudioPlayer
    let playlistId: Int
    var playlist: PlaylistModel?
    var tracks: [TrackModel] = []
    var titleCell: TitleCell?

    init (player: AudioPlayer, id: Int) {
        self.player = player
        self.playlistId = id
        super.init(nibName: nil, bundle: nil)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 + self.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.titleCell
            cell?.titleLabel.text = self.playlist?.title
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
            cell?.btn.tag = indexPath.row
            cell?.track = self.tracks[indexPath.row - 1]
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trackCell = self.tableView.cellForRow(at: indexPath) as? TrackCell {
            player.playTrack(cell: trackCell)
        } else {
            return
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.row == 0 {
            return nil
        }

        let track = self.tracks[indexPath.row - 1]
        let menuTitle = (track.artist?.name ?? "Artist") + " - " + (track.title  ?? "Track")

        let configuration = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ -> UIMenu? in

            var likeAction = UIAction(title: "Like", image: UIImage(systemName: "heart"), identifier: nil) { _ in
                TrackModel.likeTrack(id: track.id ?? 0) {_ in
                    self.tracks[indexPath.row - 1].isInFavorites = true
                } onError: {err in
                    debugPrint(err)
                    self.showAlert(title: "Error", message: err.localizedDescription)
                }
            }
            if track.isInFavorites ?? false {
                likeAction = UIAction(title: "Dislike", image: UIImage(systemName: "heart.slash"), identifier: nil) { _ in
                    TrackModel.dislikeTrack(id: track.id ?? 0) {_ in
                        self.tracks[indexPath.row - 1].isInFavorites = false
                    } onError: {err in
                        debugPrint(err)
                        self.showAlert(title: "Error", message: err.localizedDescription)
                    }
                }
            }
            let openAlbumAction = UIAction(title: "Open album page", image: UIImage(systemName: "opticaldisc"), identifier: nil) { _ in
                self.navigationController?.pushViewController(AlbumController(player: self.player, id: track.album?.id ?? 0), animated: true)
            }
            let openArtistAction = UIAction(title: "Open artist page", image: UIImage(systemName: "person.circle"), identifier: nil) { _ in
                self.navigationController?.pushViewController(ArtistController(player: self.player, id: track.artist?.id ?? 0), animated: true)
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { _ in
                guard let url = URL(string: "https://lostpointer.site/playlist/\(self.playlist?.id ?? 0)") else {
                    return
                }
                let shareSheetVC = UIActivityViewController(
                    activityItems: [url], applicationActivities: nil
                )
                self.present(shareSheetVC, animated: true)
            }
            return UIMenu(title: menuTitle, children: [likeAction, openAlbumAction, openArtistAction, shareAction])
        }
        return configuration
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        PlaylistModel.getPlaylist(id: self.playlistId) {[weak self] loadedPlaylist in
            self?.playlist = loadedPlaylist
            self?.tracks = self?.playlist?.tracks ?? []

            guard let tableView = self?.tableView else { return }
            self?.view.addSubview(tableView)

            self?.view.backgroundColor = UIColor(named: "backgroundColor")

            guard let safeArea = self?.view.safeAreaLayoutGuide else { return }

            NSLayoutConstraint.activate([
                tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
                tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor)
            ])

            self?.titleCell = self?.tableView.dequeueReusableCell(withIdentifier: "TitleCell") as? TitleCell

        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
        }
    }
}
