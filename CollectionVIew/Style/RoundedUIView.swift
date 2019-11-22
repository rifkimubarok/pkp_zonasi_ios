//
//  RoundedUIView.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 21/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class RoundedUIView: UIView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.layer.cornerRadius = 5
//        self.clipToBounds = true
    }
    

}
