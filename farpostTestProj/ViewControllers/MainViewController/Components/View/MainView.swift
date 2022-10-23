import UIKit

protocol MainViewProtocol: AnyObject {
//    func selectItem(_ index: Int)
}

class MainView: UIView {
    
    private lazy var imageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    public var delegate: MainViewProtocol?
    
    public var dataSource: [String] = ["https://upload.wikimedia.org/wikipedia/commons/1/13/Rhamnus_frangula_13_ies.jpg", "https://upload.wikimedia.org/wikipedia/commons/2/2e/Steel-bridge-800x600.JPG", "https://upload.wikimedia.org/wikipedia/commons/5/5a/Euphorbia_squarrosa.jpeg", "https://petapixel.com/assets/uploads/2020/12/riverjpg-800x600.jpg", "https://aviationweek.com/sites/default/files/styles/crop_freeform/public/2022-10/atlas_air_747-8f_source_boeing.jpeg?itok=vzYTtPpU"] {
        
        didSet {
            imageCollectionView.reloadData()
            imageCollectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: .top)
        }
    }
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setupViews()
        layoutConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageCollectionView)
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: topAnchor),
            imageCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            imageCollectionView.rightAnchor.constraint(equalTo: rightAnchor),
            imageCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}

extension MainView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as!
        ImageCollectionViewCell
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? ImageCollectionViewCell {
            cell.setupData(dataSource[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 370, height: 370)
    }
//
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        delegate?.selectItem(indexPath.row)
    }

