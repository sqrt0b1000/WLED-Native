import UIKit
import WebKit

class DeviceViewController: UIViewController, WKUIDelegate {

    var webView: WKWebView!
    var device: Device?
    var position: Int?
    
    override func loadView() {
        super.loadView()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: CGRect(x: 0, y: 0, width: 400, height: 400), configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        
        guard let deviceAddress = device?.address else {
            return
        }
        
        let deviceUrl = URL(string: "http://\(deviceAddress)")
        let request = URLRequest(url: deviceUrl!)
        // TODO: custom error page
        webView.load(request)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.isTranslucent = true
    }
}