import UIKit

public protocol OkayActionDelegate: AnyObject {
    /// It is called when pop up is dismissed by tap outside
    func okayAction()
}

class CustomAlertVC: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet var okayAction: UIButton!
    
    var titleString: String?
    var messageString: String?
    open weak var delegate: OkayActionDelegate?
    
    static func instantiate() -> CustomAlertVC? {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(CustomAlertVC.self)") as? CustomAlertVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titleString
        messageLabel.text = messageString
    }
    
    // MARK: Actions
    @IBAction func closeButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.okayAction()
    }
    
}
