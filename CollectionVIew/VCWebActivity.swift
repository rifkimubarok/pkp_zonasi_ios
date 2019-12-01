//
//  VCWebActivity.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 01/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit

class VCWebActivity: UIViewController {
    
    var stringModule : String = ""
    let username = UserDefaults.standard.string(forKey: "username") ?? ""
    let password = UserDefaults.standard.string(forKey: "password") ?? ""
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(string: stringModule)!))
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension VCWebActivity : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        print("Any cookies")
      guard let response = navigationResponse.response as? HTTPURLResponse,
        let url = navigationResponse.response.url else {
        decisionHandler(.cancel)
        return
      }

      if let headerFields = response.allHeaderFields as? [String: String] {
        let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
        cookies.forEach { cookie in
            
            print(cookie)
        self.webView.configuration.websiteDataStore.httpCookieStore.setCookie(cookie)
        }
      }
      
      decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard let url = webView.url else {return}
        let urlString = url.absoluteString
        
        if urlString.contains("login") {
            let fillForm = String(format: "document.getElementById('username').value = '\(String(describing: username))';document.getElementById('password').value = '\(String(describing: password))';")
            webView.evaluateJavaScript(fillForm) { (result, error) in
                if error != nil{
                    print("Having trouble")
                }
                DispatchQueue.main.async { webView.evaluateJavaScript("document.forms[0].submit();")
                }
            }
        }
        
    }
}
