import UIKit

class SectionHeaderFilteredList: UICollectionReusableView {
    static let reuseIdentifier = "SectionHeaderFilteredList"

    let contentContainer = UIView()
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension SectionHeaderFilteredList {

    func configure() {
        addSubview(contentContainer)
        contentContainer.translatesAutoresizingMaskIntoConstraints = false

        contentContainer.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = DSColor.darkGray
        label.font = UIFont.boldSystemFont(ofSize: 18)

        let inset = CGFloat(12)
        NSLayoutConstraint.activate([
            contentContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            contentContainer.trailingAnchor.constraint(equalTo: trailingAnchor),
            contentContainer.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            contentContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            contentContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(15)),

            label.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(25)),
            label.topAnchor.constraint(equalTo: topAnchor, constant: inset),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset),
            label.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor, constant: inset),
            label.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor, constant: -inset)

        ])
    }
}

