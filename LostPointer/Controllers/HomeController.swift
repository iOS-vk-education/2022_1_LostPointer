import UIKit

class HomeController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let tableView = UITableView()

    var tracks: [TrackModel] = []
//    var artists: [ArtistModel] = []

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + self.tracks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumsCell", for: indexPath) as? AlbumsCell
            return cell ?? UITableViewCell()
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
            cell?.track = tracks[indexPath.row - 1]
            return cell ?? UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 480
        } else {
            return 80
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TrackModel.getHomeTracks(onSuccess: {(loadedTracks: [TrackModel]) -> Void in
            self.tracks = loadedTracks

            self.view.addSubview(self.tableView)

            self.view.backgroundColor = UIColor(named: "backgroundColor")

            self.tableView.translatesAutoresizingMaskIntoConstraints = false

            self.tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
            self.tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor).isActive = true
            self.tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor).isActive = true
            self.tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true

            self.tableView.dataSource = self
            self.tableView.delegate = self

            self.tableView.register(AlbumsCell.self, forCellReuseIdentifier: "AlbumsCell")
            self.tableView.register(TrackCell.self, forCellReuseIdentifier: "TrackCell")
        }, onError: {(err: Error) -> Void in
            print(err)
        })
    }

}
