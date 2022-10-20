
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
        view.backgroundColor = .blue
        setupViews()
        layoutConstraints()
    }
    
    func setupViews() {
        view.addSubview(mainView)
    }
    
    func layoutConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.topAnchor),
//            mainView.heightAnchor.constraint(equalToConstant: 230),
            mainView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mainView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
//    
//    func selectItem(_ index: Int) {
//        return
//    }
}

