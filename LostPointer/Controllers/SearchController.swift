import UIKit

final class SearchController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {
    let tableView = UITableView()
    let player: AudioPlayer
    var tracks: [TrackModel] = []
    var albums: [AlbumModel] = []
    var artists: [ArtistModel] = []

    var searchInputCell: TextInputTableViewCell?
    var albumsCell: HomeAlbumsCell?
    var artistsCell: ArtistsCell?
    var trackCells: [TrackCell] = []

    init (player: AudioPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)

        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.tableView.register(TextInputTableViewCell.self, forCellReuseIdentifier: "TextInputTableViewCell")
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
        1 + self.tracks.count + 1 + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            // первая ячейка - searchInput
            return self.searchInputCell ?? UITableViewCell()
        } else if indexPath.row == self.tracks.count + 1 {
            // ячейка после треков - артисты
            return self.artistsCell ?? UITableViewCell()
        } else if indexPath.row == self.tracks.count + 1 + 1 {
            // вторая ячейка - альбомы
            return self.albumsCell ?? UITableViewCell()
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
        if indexPath.row == 1 + self.tracks.count + 1 + 1 {
            // первая ячейка - альбомы
            return 480
        } else if indexPath.row == 1 + self.tracks.count + 1 {
            // ячейка после треков - артисты
            return 290
        } else {
            // все остальные ячейки
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trackCell = self.tableView.cellForRow(at: indexPath) as? TrackCell {
            player.playTrack(cell: trackCell)
            player.setContext(context: trackCells, currentTrack: indexPath.row - 1)
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

    override func viewDidLoad() {
        super.viewDidLoad()

        let dispatchGroup = DispatchGroup()

        dispatchGroup.enter()
        TrackModel.getHomeTracks {[weak self] _ in
            self?.tracks = []
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

            let searchModel = TextInputFormItem(
                text: "",
                placeholder: "Search...",
                didChange: { text in
                    debugPrint(text)
                    UserModel.search(text: text) {[weak self] searchResult in
                        self?.tracks = searchResult.tracks ?? []
                        self?.albums = searchResult.albums ?? []
                        self?.artists = searchResult.artists ?? []

                        self?.albumsCell?.albums = self?.albums ?? []
                        self?.albumsCell?.albumsCollectionView?.reloadData()
                        self?.tableView.reloadData()
                        self?.artistsCell?.artists = self?.artists ?? []
                        self?.artistsCell?.artistsCollectionView?.reloadData()
                    } onError: {[weak self] err in
                        debugPrint(err)
                        self?.showAlert(title: "Error", message: err.localizedDescription)
                    }
                }
            )

            self.searchInputCell = self.tableView.dequeueReusableCell(withIdentifier: "TextInputTableViewCell") as? TextInputTableViewCell
            self.albumsCell = self.tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsCell") as? HomeAlbumsCell
            self.artistsCell = self.tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") as? ArtistsCell
            self.searchInputCell?.configure(for: searchModel)
            self.albumsCell?.load(player: self.player, navigator: self.navigationController, forSearch: true)
            self.artistsCell?.load(player: self.player, navigator: self.navigationController, forSearch: true)
        }
    }
}
