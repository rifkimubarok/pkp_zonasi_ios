//
//  VCModuleFile.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 02/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class VCModuleFile: UIViewController, UINavigationControllerDelegate {
    let documentInteractionController = UIDocumentInteractionController()
    var content : [contentObj]?
    var title_ : String = ""
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        documentInteractionController.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: "ModuleFileCell", bundle: nil), forCellReuseIdentifier: "FileItemCell")
        navigationController?.title = title_
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
//
//    @IBAction func btnClicked(_ sender: UIButton) {
//        storeAndShare(withURLString: "http://223.27.153.196/webservice/pluginfile.php/32003/mod_folder/content/11/LKPD%201.docx?forcedownload=1&token=8c52afd4844670a75399d0b0587cb1c2")
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func share(url: URL) {
        print(url)
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
    
    /// This function will store your document to some temporary URL and then provide sharing, copying, printing, saving options to the user
    func storeAndShare(withURLString: String) {
        guard let url = URL(string: withURLString) else { return }
        /// START YOUR ACTIVITY INDICATOR HERE
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else { return }
            let tmpURL = FileManager.default.temporaryDirectory
                .appendingPathComponent(response?.suggestedFilename ?? "generated")
            do {
                try data.write(to: tmpURL)
            } catch {
                print(error)
            }
            DispatchQueue.main.async {
                /// STOP YOUR ACTIVITY INDICATOR HERE
                self.share(url: tmpURL)
            }
            }.resume()
    }

}

extension VCModuleFile: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
}

extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}

extension VCModuleFile : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return content!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FileItemCell", for: indexPath) as! ModuleFileCell
        let item = content?[indexPath.item]
        cell.file_name.text = item?.filename
        
        switch item?.mimetype {
        case "application/pdf":
            cell.file_image.image = UIImage(named:"pdf")!.resizeImage(CGFloat(32.0), opaque: false)
            break
        case "application/vnd.openxmlformats-officedocument.wordprocessingml.document" :
            cell.file_image.image = UIImage(named:"doc")!.resizeImage(CGFloat(32.0), opaque: false)
            break
        case "application/vnd.openxmlformats-officedocument.presentationml.slideshow" :
            cell.file_image.image = UIImage(named:"ppt")!.resizeImage(CGFloat(32.0), opaque: false)
            break
        default:
            cell.file_image.image = UIImage(named:"file")!.resizeImage(CGFloat(32.0), opaque: false)
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = content?[indexPath.item]
        let token = UserDefaults.standard.string(forKey: "token")!
        var url = item?.fileurl
        let itemArr = url!.split{$0 == "?"}.map(String.init)
        if itemArr.count > 1 {
            url = url! + "&token=\(token)"
        }else{
            url = url! + "?token=\(token)"
        }
//        print(url)
//        DispatchQueue.main.async {
            storeAndShare(withURLString: url!)
//        }
    }
}
