import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let player: AudioPlayer = AudioPlayer()
    var tracks: [TrackModel] = []
    var albumsCell: AlbumsCell?
    var artistsCell: ArtistsCell?

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
            //            if trackCell.togglePlaying() {
            player.playTrack(cell: trackCell)
            //            } else {
            //                player.toggle()
            //            }
        } else {
            return
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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

            self.tableView.register(AlbumsCell.self, forCellReuseIdentifier: "AlbumsCell")
            self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
            self.tableView.register(ArtistsCell.self, forCellReuseIdentifier: "ArtistsCell")

            self.albumsCell = self.tableView.dequeueReusableCell(withIdentifier: "AlbumsCell") as? AlbumsCell
            self.artistsCell = self.tableView.dequeueReusableCell(withIdentifier: "ArtistsCell") as? ArtistsCell
            self.albumsCell?.load()
            self.artistsCell?.load()

        } onError: {err in
            print(err)
        }
    }
}
