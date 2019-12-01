//
//  VCProfile.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 17/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class VCProfile: UIViewController {
    
    @IBAction func logout(_ sender: Any) {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.main.bundleIdentifier!)
        UserDefaults.standard.set(false, forKey: "status")
        Switcher.updateRootVC()
    }
}
