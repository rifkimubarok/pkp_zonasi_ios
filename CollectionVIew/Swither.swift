//
//  Swither.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 17/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import Foundation
import UIKit

class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaults.standard.bool(forKey: "status")
        var rootVC : UIViewController?
        
        print(status)
        
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vctabbar") as! VCTabBar
//            let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                   appDelegate.window?.rootViewController?.show(rootVC!, sender: nil)
        }
        else{
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vclogin") as! VCLogin
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        print(appDelegate.window?.rootViewController?.navigationController as Any)
        appDelegate.window?.rootViewController?.show(rootVC!, sender: nil)
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        appDelegate.window?.rootViewController.prese
        
    }
    
}
