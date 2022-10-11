import UIKit

class SectionHeaderView: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderView"

    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionHeaderView {
    func configure() {
        addSubview(label)

        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DSColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 22)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -inset),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

