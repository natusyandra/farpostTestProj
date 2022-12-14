import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    let imageViewInCell: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageViewInCell.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        imageViewInCell.image = nil
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(imageViewInCell)
        contentView.clipsToBounds = true
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
            imageViewInCell.rightAnchor.constraint(equalTo: rightAnchor),
            imageViewInCell.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageViewInCell.leftAnchor.constraint(equalTo: leftAnchor),
            imageViewInCell.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
    public func setupData(_ data: String) {
        DispatchQueue.global(qos: .background).async { [self] in
            self.imageViewInCell.imageFromServerURL(data, placeHolder: .add)
        }
    }
}


