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
    var titleNav : String = ""
    let dialog = CustomDialog.instance
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        
        // Do any additional setup after loading the view.
        webView.load(URLRequest(url: URL(string: stringModule)!))
        navigationItem.title = self.titleNav
    }
    

    /*
    // MARK: - Navigation p

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func goBack(_ sender: UIBarButtonItem) {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @IBAction func goForward(_ sender: Any) {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    @IBAction func reload(_ sender: Any) {
        webView.reload()
    }
}

extension VCWebActivity : WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
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
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
       guard let url = webView.url else {return}
        let urlString = url.absoluteString
        if urlString.contains("login") {
            webView.isHidden = true
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dialog.showLoaderView()
        
        guard let url = webView.url else {return}
        let urlString = url.absoluteString
        if urlString.contains("login") {
            webView.isHidden = true
        }
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
        }else{
            webView.isHidden = false
        }
        
        dialog.hideLoaderView()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        dialog.hideLoaderView()
    }
}
