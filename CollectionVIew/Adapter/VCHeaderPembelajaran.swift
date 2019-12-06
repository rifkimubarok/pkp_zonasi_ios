//
//  VCHeaderPembelajaran.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 05/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit

class VCHeaderPembelajaran: UIViewController, UINavigationControllerDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    var apiHelper = ApiHelper()
    var getLink = GetLink()
    var headerSectionOb : sectionObj?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        webView.navigationDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(loadHeader), name:NSNotification.Name(rawValue: "loadHeader"), object: nil)
        
        self.tableView.register(UINib(nibName: "ModuleFileCell", bundle: nil), forCellReuseIdentifier: "FileItemCell")
        // Do any additional setup after loading the view.
    }
    
    @objc func  loadHeader(notification: NSNotification){
        let data = notification.userInfo
        headerSectionOb = data!["section"] as! sectionObj
        var summaryText : String = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"></HEAD><BODY>" + headerSectionOb!.summary + "</BODY></HTML>"
        DispatchQueue.main.async {
            self.tableView.reloadData()
            summaryText = self.getLink.fixedLink(text: summaryText)
            self.webView.loadHTMLString(summaryText, baseURL: URL(string: self.apiHelper.EndPointAPI))
        }
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

extension VCHeaderPembelajaran : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return headerSectionOb?.modules.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileItemCell", for: indexPath) as! ModuleFileCell
        let module = headerSectionOb?.modules[indexPath.item]
        cell.file_name.text = module?.name
        let urlImage = apiHelper.urlforImage + module!.modicon
        cell.file_image.sd_setImage(with: URL(string: urlImage))
        return cell
    }
    
}

extension VCHeaderPembelajaran : WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let jsString = "var style = document.createElement('style'); style.innerHTML = '\(WebCss.instance.homecss)'; document.head.appendChild(style);"
        webView.evaluateJavaScript(jsString)
    }
}
