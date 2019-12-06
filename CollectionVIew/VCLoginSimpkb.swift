//
//  VCLoginSimpkb.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 19/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit

class VCLoginSimpkb: UIViewController,WKNavigationDelegate,UINavigationControllerDelegate{

    @IBOutlet weak var webView: WKWebView!
    var number_inject : Int = 0
    let apiHelper = ApiHelper()
    
    let dialog = CustomDialog.instance
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self
        navigationController?.setNavigationBarHidden(false, animated: true)
        var urlString : String = apiHelper.EndPointAPI
        urlString += "admin/tool/mobile/launch.php?service=moodle_mobile_app&urlscheme=pkpzonasi://login/token?param=&passport="
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        webView.load(request)
//        self.webView.addObserver(self, forKeyPath: #keyPath(WKWebView.isLoading), options: .new, context: nil)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        print(keyPath!)
//        if keyPath == "loading" {
//
//            if webView.isLoading {
//
//                print("Loading")
//            }else {
//                if self.number_inject == 0 {
//                    let username : String = UserDefaults.standard.string(forKey: "username")!
//                    let password : String = UserDefaults.standard.string(forKey: "password")!
//                    let js = "javascript:" +
//                    "document.getElementById('password').value = '" + password + "';"  + "document.getElementById('username').value = '" + username + "' ;document.forms[0].submit()";
//                    webView.evaluateJavaScript(js) { (result,Error) in
//
//                    }
//
//
//                }
//                self.number_inject += 1
////                print(webView.url!)
//            }
//
//        }
//
//    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        switch navigationAction.request.url?.scheme {
        case "tel":
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
            break
        case "pkpzonasi" :
            print("Magic Link detected")
            UIApplication.shared.open(navigationAction.request.url!, options: [:], completionHandler: nil)
            decisionHandler(.cancel)
        break
        default:
            decisionHandler(.allow)
            break
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dialog.showLoaderView()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let username : String = UserDefaults.standard.string(forKey: "username")!
        let password : String = UserDefaults.standard.string(forKey: "password")!
        let js = "javascript:" +
        "document.getElementById('password').value = '" + password + "';"  + "document.getElementById('username').value = '" + username + "' ;";
        webView.evaluateJavaScript(js) { (result, error) in
            if error != nil{
                print("Having trouble")
            }
            DispatchQueue.main.async { webView.evaluateJavaScript("document.forms[0].submit();")
            }
        }
        dialog.hideLoaderView()
    }
}

