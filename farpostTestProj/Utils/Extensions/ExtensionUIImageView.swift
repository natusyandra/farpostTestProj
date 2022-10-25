import UIKit

extension UIImageView {
    
    func imageFromServerURL(_ URLString: String, placeHolder: UIImage?) {
        
        let imageServerUrl = URLString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        if let image = ImageCache.getImage(urlString: imageServerUrl) {
            DispatchQueue.main.async {
                print("ImageCache")
                self.image = image
            }
            return
        }
        
        if let url = URL(string: imageServerUrl) {
            URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
                print("URLSession load image")
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
