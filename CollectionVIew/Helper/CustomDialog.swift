//
//  CustomDialog.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 19/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//


import UIKit

class CustomDialog: UIView {
    
    static let instance = CustomDialog()
    
    var viewColor: UIColor = .black
    var setAlpha: CGFloat = 0.5
    var gifName: String = "demo"
    
    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        transparentView.isUserInteractionEnabled = false
        transparentView.clipsToBounds = true
        return transparentView
    }()
    
    lazy var gifImage: UIImageView = {
        var gifImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        gifImage.contentMode = .scaleAspectFit
        gifImage.center = transparentView.center
        gifImage.isUserInteractionEnabled = false
        gifImage.loadGif(name: gifName)
        return gifImage
    }()
    
    func showLoaderView() {
        self.addSubview(self.transparentView)
        self.transparentView.addSubview(self.gifImage)
        self.transparentView.bringSubviewToFront(self.gifImage)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func hideLoaderView() {
        self.transparentView.removeFromSuperview()
        UIApplication.shared.endIgnoringInteractionEvents() 
    }
    
}
