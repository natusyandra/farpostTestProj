import UIKit

class MainViewController: UIViewController, MainViewProtocol {
    
    private lazy var mainView: MainView = {
        var view = MainView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationController?.isNavigationBarHidden = false
        setupViews()
        layoutConstraints()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        guard let flowLayout = mainView.imageCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        flowLayout.invalidateLayout()
    }
    
    func setupViews() {
        view.addSubview(mainView)
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    //
    //    func selectItem(_ index: Int) {
    //        return
    //    }
}

