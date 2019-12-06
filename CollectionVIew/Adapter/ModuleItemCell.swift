//
//  ModuleItemCell.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 30/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
class ModuleItemCell: UITableViewCell {

    @IBOutlet weak var module_name: UILabel!
    @IBOutlet weak var module_image: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        module_name.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Co nfigure the view for the selected state
    }
    

}
