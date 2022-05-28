import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate {

    let tableView = UITableView()
    let player: AudioPlayer
    var tracks: [TrackModel] = []
    var albumsCell: HomeAlbumsCell?
    var artistsCell: ArtistsCell?

    let refreshControl = UIRefreshControl()

    init (player: AudioPlayer) {
        self.player = player
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
            return self.albumsCell ?? UITableViewCell()
        } else if indexPath.row == self.tracks.count + 1 {
            return self.artistsCell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
            cell?.btn.tag = indexPath.row
            cell?.track = tracks[indexPath.row - 1]
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 480
        } else if indexPath.row == self.tracks.count + 1 {
            return 290
        } else {
            return 80
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let trackCell = self.tableView.cellForRow(at: indexPath) as? TrackCell {
            player.playTrack(cell: trackCell)
        } else {
            self.navigationController?.pushViewController(ArtistController(player: self.player, id: 369), animated: true)
        }
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        if indexPath.row == 0 || indexPath.row == self.tracks.count + 1 {
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
            let openArtistAction = UIAction(title: "Open artist page", image: UIImage(systemName: "person.circle"), identifier: nil) { _ in
                self.navigationController?.pushViewController(ArtistController(player: self.player, id: track.artist?.id ?? 0), animated: true)
            }
            let playlistAction = UIAction(title: "Add to the playlist...", image: nil, identifier: nil) { _ in
                // Put button handler here
            }
            let shareAction = UIAction(title: "Share", image: UIImage(systemName: "square.and.arrow.up"), identifier: nil) { _ in
                // Put button handler here
            }
            return UIMenu(title: menuTitle, children: [likeAction, openAlbumAction, openArtistAction, playlistAction, shareAction])
        }
        return configuration
    }

    @objc func refresh(_ sender: AnyObject) {
        self.load()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)

        self.load()
    }

    func load() {
        TrackModel.getHomeTracks {loadedTracks in
            self.tracks = loadedTracks

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

            self.tableView.register(HomeAlbumsCell.self, forCellReuseIdentifier: "HomeAlbumsCell")
            self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
            self.tableView.register(ArtistsCell.self, forCellReuseIdentifier: "ArtistsCell")

            self.albumsCell = self.tableView.dequeueReusableCell(withIdentifier: "HomeAlbumsCell") as? HomeAlbumsCell
            self.artistsCell = self.tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") as? ArtistsCell
            self.albumsCell?.load(player: self.player, navigator: self.navigationController)
            self.artistsCell?.load(player: self.player, navigator: self.navigationController)

            self.refreshControl.endRefreshing()

        } onError: {err in
            debugPrint(err)
            self.refreshControl.endRefreshing()
        }
    }
}
