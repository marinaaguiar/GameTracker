import UIKit

class ExplorerCollectionViewCell: UICollectionViewCell {
    static let identifier = "ExplorerCollectionViewCell"

    private let view = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(view)
        contentView.clipsToBounds = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        view.clipsToBounds = true
        view.frame = contentView.bounds
        view.backgroundColor = .systemPink
    }
}
