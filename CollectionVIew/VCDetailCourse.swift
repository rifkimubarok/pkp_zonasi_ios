//
//  VCDetailCourse.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 22/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import WebKit

class VCDetailCourse: UIViewController{

    var course_id : Int = -1;
    @IBOutlet weak var ContainerAktifitas: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.title = "Aktivitas"
//        guard let childVC = self.storyboard?.instantiateViewController(withIdentifier: "detailCourse") as? PembelajaranCollectionVC else { return }
//        childVC.Text = "Hi Tayo"
//        ContainerAktifitas.addSubview(childVC.view)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "load"), object: nil,userInfo: ["courseId" : course_id])
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Hi Tayo")
    }

}
