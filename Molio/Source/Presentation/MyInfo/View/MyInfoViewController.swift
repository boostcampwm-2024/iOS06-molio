import SwiftUI

final class MyInfoViewController: UIHostingController<MyInfoView> {
    // MARK: - Initializer
    
    init(viewModel: MyInfoViewModel) {
        let myInfoView = MyInfoView(viewModel: viewModel)
        super.init(rootView: myInfoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "내 정보"
        
        setupButtonAction()
    }
    
    // MARK: - Private func
    
    private func setupButtonAction() {
        rootView.didTapUpdateConfirmButton = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}
