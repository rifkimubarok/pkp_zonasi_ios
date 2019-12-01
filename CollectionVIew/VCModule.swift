//
//  VCModule.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 30/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit

class VCModule: UIViewController {
    var moduleArr : sectionObj! = nil
    var courseId : Int = -1
    var apiHelper = ApiHelper()
    var getLink = GetLink()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var webView: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        navigationItem.title = moduleArr.name
        var summaryText : String = "<HTML><HEAD><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, shrink-to-fit=no\"><style>img{width:100% !important;height:auto !important;}</style></HEAD><BODY>" + moduleArr.summary + "</BODY></HTML>"
        let token = UserDefaults.standard.string(forKey: "token")  ?? ""
        let result = getLink.matches(for: "(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]", in: summaryText)
        for item in result {
            let itemArr = item.split{$0 == "?"}.map(String.init)
            var url : String = "";
            if itemArr.count > 1 {
                url = itemArr[0] + "?" + itemArr[1] + "&token=" + token;
            }else{
                url = item + "?token=" + token;
            }
            summaryText = summaryText.replacingOccurrences(of: item, with: url)
        }
        webView.loadHTMLString(summaryText, baseURL: URL(string: apiHelper.EndPointAPI))
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

extension VCModule : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Banyak Data : " , self.moduleArr.modules.count)
        return self.moduleArr.modules.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableModule", for: indexPath) as! ModuleItemCell
        let module = self.moduleArr.modules[indexPath.item]
        let urlImage = apiHelper.urlforImage + module.modicon
        cell.module_image.sd_setImage(with: URL(string: urlImage))
        cell.module_name.text = module.name
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let module = self.moduleArr.modules[indexPath.item]
        DispatchQueue.main.async {
            self.navigateToSection(module: module)
        }
    }
    
    func navigateToSection(module : moduleObj) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "webViewActivity") as! VCWebActivity
        newViewController.stringModule = module.url ?? ""
        self.show(newViewController, sender: .none)
    }
    
}

extension VCModule : UIWebViewDelegate{
    
}
