//
//  HeaderItem.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 03/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit

class HeaderItem: UICollectionReusableView {
        
    @IBOutlet weak var webView: WKWebView!
    
    @IBOutlet weak var viewHeader: UIView!
    override func awakeFromNib() {
        webView.navigationDelegate = self
    }
}

extension HeaderItem : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(WebCss.instance.homecss)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString)
    }
}
