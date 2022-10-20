
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    static let identifier = "ImageCollectionViewCell"
    
    private let tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        imageView.image = UIImage(named: "bikeImage")
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableImageView.frame = contentView.bounds
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
//        contentView.layer.cornerRadius = 13.91
//        contentView.layer.borderWidth = 1
//        contentView.layer.borderColor = UIColor(red: 0.878, green: 0.878, blue: 0.878, alpha: 1).cgColor
        contentView.backgroundColor = .green
        contentView.addSubview(tableImageView)
        contentView.clipsToBounds = true
        
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
//            tableImageView.rightAnchor.constraint(equalTo: rightAnchor),
//            tableImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            tableImageView.widthAnchor.constraint(equalToConstant: 102),
            tableImageView.heightAnchor.constraint(equalToConstant: 84),
            tableImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            tableImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
        ])
    }
}
