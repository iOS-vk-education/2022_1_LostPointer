import UIKit

final class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    let tableView = UITableView()
    let player: AudioPlayer
    var tracks: [TrackModel] = []
    var playlists: [PlaylistModel] = []
    var albums: [AlbumModel] = []
    var artists: [ArtistModel] = []

    var albumsCell: HomeAlbumsCell?
    var artistsCell: ArtistsCell?
    var playlistsTitleCell: TitleCell?
    var trackCells: [TrackCell] = []

    let refreshControl = UIRefreshControl()

    init (player: AudioPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.register(HomeAlbumsCell.self, forCellReuseIdentifier: "HomeAlbumsCell")
        self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
        self.tableView.register(ArtistsCell.self, forCellReuseIdentifier: "ArtistsCell")
        self.tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
        self.tableView.register(PlaylistCell.self, forCellReuseIdentifier: "PlaylistCell")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1 + self.tracks.count + 1 + 1 + self.playlists.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // первая ячейка - альбомы
            return self.albumsCell ?? UITableViewCell()
        } else if indexPath.row == self.tracks.count + 1 {
            // ячейка после треков - артисты
            return self.artistsCell ?? UITableViewCell()
        } else if indexPath.row == self.tracks.count + 1 + 1 {
            // ячейка после после артистов - label
            let cell = self.playlistsTitleCell
            cell?.titleLabel.text = "Playlists"
            return cell ?? UITableViewCell()
        } else if indexPath.row > self.tracks.count + 1 + 1 {
            // ячейка после после label - плейлисты
            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaylistCell", for: indexPath) as? PlaylistCell
            cell?.playlist = playlists[indexPath.row - 1 - 1 - 1 - self.tracks.count]
            return cell ?? UITableViewCell()
        } else {
            // ячейка трека
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell else {
                return UITableViewCell()
            }
            cell.btn.tag = indexPath.row
            cell.track = tracks[indexPath.row - 1]
            trackCells.append(cell)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // первая ячейка - альбомы
        if indexPath.row == 0 {
            return 480
            // ячейка после треков - артисты
        } else if indexPath.row == self.tracks.count + 1 {
            return 290
            // все остальные ячейки
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trackCell = self.tableView.cellForRow(at: indexPath) as? TrackCell {
            player.playTrack(cell: trackCell)
            player.setContext(context: trackCells, currentTrack: indexPath.row - 1)
        } else if let playlistCell = self.tableView.cellForRow(at: indexPath) as? PlaylistCell {
            print(playlistCell)
            self.navigationController?.pushViewController(PlaylistController(player: self.player, id: playlistCell.playlist?.id ?? 0), animated: true)
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        // если не ячейка с треком, выходим
        if indexPath.row == 0 || indexPath.row > self.tracks.count {
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
                guard let url = URL(string: "https://lostpointer.site/album/\(track.album?.id ?? 0)") else {
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

    @objc func refresh(_ sender: AnyObject) {
        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        AlbumModel.getHomeAlbums {[weak self] loadedAlbums in
            self?.albums = loadedAlbums
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
            self?.refreshControl.endRefreshing()
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        TrackModel.getHomeTracks {[weak self] loadedTracks in
            self?.tracks = loadedTracks
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
            self?.refreshControl.endRefreshing()
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        ArtistModel.getHomeArtists { [weak self] loadedArtists in
            self?.artists = loadedArtists
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
            self?.refreshControl.endRefreshing()
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        PlaylistModel.getHomePublicPlaylists {[weak self] publicPlaylists in
            self?.playlists = publicPlaylists
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
            self?.refreshControl.endRefreshing()
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            DispatchQueue.main.async {
                self.albumsCell?.albums = self.albums
                self.albumsCell?.albumsCollectionView?.reloadData()
                self.tableView.reloadData()
                self.artistsCell?.artists = self.artists
                self.artistsCell?.artistsCollectionView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        TrackModel.getHomeTracks {[weak self] loadedTracks in
            self?.tracks = loadedTracks
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.enter()
        PlaylistModel.getHomePublicPlaylists {[weak self] publicPlaylists in
            self?.playlists = publicPlaylists
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        } onError: {[weak self] err in
            debugPrint(err)
            self?.showAlert(title: "Error", message: err.localizedDescription)
            DispatchQueue.main.async {
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            self.view.addSubview(self.tableView)

            self.view.backgroundColor = UIColor(named: "backgroundColor")

            NSLayoutConstraint.activate([
                self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
                self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
                self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
                self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
            ])

            self.albumsCell = self.tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsCell") as? HomeAlbumsCell
            self.artistsCell = self.tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") as? ArtistsCell
            self.playlistsTitleCell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell") as? TitleCell
            self.albumsCell?.load(player: self.player, navigator: self.navigationController)
            self.artistsCell?.load(player: self.player, navigator: self.navigationController)
        }
    }
}
