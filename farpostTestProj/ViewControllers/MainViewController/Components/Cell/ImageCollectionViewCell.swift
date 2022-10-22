
import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageCollectionViewCell"
    
    var tableImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableImageView.frame = contentView.bounds
    }
    
    override init(frame: CGRect) {
        super .init(frame: frame)
        contentView.addSubview(tableImageView)
        contentView.clipsToBounds = true
        
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
            tableImageView.rightAnchor.constraint(equalTo: rightAnchor),
            tableImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            tableImageView.leftAnchor.constraint(equalTo: leftAnchor),
            tableImageView.topAnchor.constraint(equalTo: topAnchor),
        ])
    }
    
//    public func setupData(_ data: String) {
//        DispatchQueue.global(qos: .background).async { [self] in
//            self.tableImageView.imageFromServerURL(data, placeHolder: .add)
//        }
//    }
    
        public func setupData(_ data: String) {
            tableImageView.imageFromServerURL(data, placeHolder: .add)
        }
}

extension UIImageView {
    // в отдебный папку
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let image = ImageCache.getImage(urlString: imageServerUrl) {
            self.image = image
            return
        }

        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                
                //print("RESPONSE FROM API: \(response)")
                if error != nil {
                    print("ERROR LOADING IMAGES FROM URL: \(error)")
                    DispatchQueue.main.async {
                        self.image = placeHolder
                    }
                    return
                }
                DispatchQueue.main.async {
                    if let data = data {
                        if let downloadedImage = UIImage(data: data) {
                            
                            self.image = downloadedImage
                            
                            ImageCache.storeImage(urlString: imageServerUrl, img: downloadedImage)
                        }
                    }
                }
            }).resume()
        }
    }
}
