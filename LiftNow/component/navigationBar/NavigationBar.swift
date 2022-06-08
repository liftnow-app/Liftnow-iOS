import Foundation
import UIKit

final class NavigationBar: UIView {
    
    private static let NIB_NAME = "NavigationBar"
    
    @IBOutlet private var view: UIView!
    @IBOutlet public weak var leftButton: UIButton!
//    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet public weak var rightSecondButton: UIButton!
    @IBOutlet public var pageCtrl: UIPageControl!
    
    var title: String = "" {
        didSet {
    //        titleLabel.text = title
        }
    }
    
    var isLeftButtonHidden: Bool {
        set {
            leftButton.isHidden = newValue
        }
        get {
            return leftButton.isHidden
        }
    }
    
    override func awakeFromNib() {
        initWithNib()
    }
    
    private func initWithNib() {
        Bundle.main.loadNibNamed(NavigationBar.NIB_NAME, owner: self, options: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        setupLayout()
    }
    
    @IBAction func onBackAction(_ sender: Any) {
     //   self.navigationController?.popViewController(animated: true);
        print("test")
    }
    
    @IBAction func onPageChanged(_ sender: Any) {
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate(
            [
                view.topAnchor.constraint(equalTo: topAnchor),
                view.leadingAnchor.constraint(equalTo: leadingAnchor),
                view.bottomAnchor.constraint(equalTo: bottomAnchor),
                view.trailingAnchor.constraint(equalTo: trailingAnchor),
            ]
        )
    }
}
