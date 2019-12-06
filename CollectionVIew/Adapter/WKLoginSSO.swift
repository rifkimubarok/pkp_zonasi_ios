//
//  WKLoginSSO.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 19/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit
class WKLoginSSO: WKWebView,WKNavigationDelegate {
 
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("Loaded")
    }
}
