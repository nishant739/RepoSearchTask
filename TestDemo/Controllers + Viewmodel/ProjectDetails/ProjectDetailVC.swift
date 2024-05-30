import UIKit
import WebKit

class ProjectDetailVC: UIViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var webView: WKWebView!
    
    // MARK: - Instance Variables
    var receivedURL = ""
    var navigationTitle = ""
    
    // MARK: - LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.topItem?.title = navigationTitle
        if let url = URL (string: receivedURL) {
            let requestObj = URLRequest(url: url)
            self.webView.load(requestObj)
        }
    }
}
