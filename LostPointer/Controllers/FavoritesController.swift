import UIKit

class FavoritesController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()
    let player: AudioPlayer
    var tracks: [TrackModel] = []
    var titleCell: TitleCell?

    init (player: AudioPlayer) {
        self.player = player
        super.init(nibName: nil, bundle: nil)
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
            cell?.titleLabel.text = "Favorites"
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
            cell?.btn.tag = indexPath.row
            cell?.track = tracks[indexPath.row - 1]
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

    override func viewDidLoad() {
        super.viewDidLoad()
        TrackModel.getFavoritesTrack {loadedTracks in
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

            self.tableView.register(TitleCell.self, forCellReuseIdentifier: "TitleCell")
            self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")

            self.titleCell = self.tableView.dequeueReusableCell(withIdentifier: "TitleCell") as? TitleCell

        } onError: {err in
            debugPrint(err)
        }
    }
}
