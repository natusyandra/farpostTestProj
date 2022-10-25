import UIKit

class MainView: UIView {
    
    public var dataSource = DataManager().images
    
    lazy var imageCollectionView: UICollectionView = {
        let layout = SelfSizingFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        view.delegate = self
        view.dataSource = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator  = false
        return view
    }()
    
    let refreshControl = UIRefreshControl()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        setupViews()
        layoutConstraints()
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(imageCollectionView)
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
            imageCollectionView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            imageCollectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            imageCollectionView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            imageCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
    
    func setupCollectionView(){
        imageCollectionView.alwaysBounceVertical = true
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing content...")
        refreshControl.addTarget(self, action: #selector(refreshImageData), for: .valueChanged)
        imageCollectionView.addSubview(refreshControl)
    }
    
    @objc func refreshImageData(refreshControl: UIRefreshControl) {
        ImageCache.removeCache()
        dataSource = DataManager().images
        imageCollectionView.reloadData()
        refreshControl.endRefreshing()
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
        let width = (collectionView.frame.size.width)
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.dataSource.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        
    }
}


