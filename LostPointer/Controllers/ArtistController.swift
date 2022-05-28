import UIKit

class ArtistController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let player: AudioPlayer
    let artistId: Int
    var artist: ArtistModel?
    var tracks: [TrackModel] = []
    var titleCell: TitleCell?
    var albumsCell: AlbumsCell?

    init (player: AudioPlayer, id: Int) {
        self.player = player
        self.artistId = id
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 + self.tracks.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = self.titleCell
            cell?.titleLabel.text = self.artist?.name
            return cell ?? UITableViewCell()
        } else if indexPath.row == self.tracks.count + 1 {
            return self.albumsCell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
            cell?.btn.tag = indexPath.row
            cell?.track = self.tracks[indexPath.row - 1]
            cell?.track?.artist = ArtistModel(id: self.artist?.id, name: self.artist?.name, avatar: self.artist?.avatar, tracks: [], albums: [])
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 80
        } else if indexPath.row == self.tracks.count + 1 {
            let pairs = Int((self.artist?.albums?.count ?? 0) / 2) + (self.artist?.albums?.count ?? 0) % 2
            let height = 160 * pairs
            return CGFloat(height)
        } else {
            return 80
        }
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
                }
            }
            if track.isInFavorites ?? false {
                likeAction = UIAction(title: "Dislike", image: UIImage(systemName: "heart.slash"), identifier: nil) { _ in
                    TrackModel.dislikeTrack(id: track.id ?? 0) {_ in
                        self.tracks[indexPath.row - 1].isInFavorites = false
                    } onError: {err in
                        debugPrint(err)
                    }
                }
            }
            let openAlbumAction = UIAction(title: "Open album page", image: UIImage(systemName: "opticaldisc"), identifier: nil) { _ in
                self.navigationController?.pushViewController(AlbumController(player: self.player, id: track.album?.id ?? 0), animated: true)
            }
            let playlistAction = UIAction(title: "Add to the playlist...", image: nil, identifier: nil) { _ in
                // Put button handler here
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { _ in
                guard let url = URL(string: "https://lostpointer.site/artist/\(track.artist?.id ?? 0)") else {
                    return
                }
                let shareSheetVC = UIActivityViewController(
                    activityItems: [url], applicationActivities: nil
                )
                self.present(shareSheetVC, animated: true)
            }
            return UIMenu(title: menuTitle, children: [likeAction, openAlbumAction, playlistAction, shareAction])
        }
        return configuration
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        ArtistModel.getArtist(id: self.artistId) {loadedArtist in
            self.artist = loadedArtist

            for var track in self.artist?.tracks ?? [] {
                track.artist = ArtistModel(id: self.artist?.id, name: self.artist?.name, avatar: self.artist?.avatar, tracks: [], albums: [])
                self.tracks.append(track)
            }

            self.view.addSubview(self.tableView)

            self.view.backgroundColor = UIColor(named: "backgroundColor")

            self.tableView.translatesAutoresizingMaskIntoConstraints = false

            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
            ])

            self.tableView.dataSource = self
            self.tableView.delegate = self

            self.tableView.register(AlbumsCell.self, forCellReuseIdentifier: "AlbumsCell")
            self.tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
            self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")

            self.albumsCell = self.tableView.dequeueReusableCell(withIdentifier: "AlbumsCell") as? AlbumsCell
            self.titleCell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell") as? TitleCell
            self.albumsCell?.load(albums: self.artist?.albums ?? [], player: self.player, navigator: self.navigationController)

        } onError: {err in
            debugPrint(err)
        }
    }
}
