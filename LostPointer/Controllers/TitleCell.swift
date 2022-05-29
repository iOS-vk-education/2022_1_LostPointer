import UIKit

class TitleCell: UITableViewCell {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.contentView.addSubview(titleLabel)

        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            titleLabel.heightAnchor.constraint(equalToConstant: 70)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
