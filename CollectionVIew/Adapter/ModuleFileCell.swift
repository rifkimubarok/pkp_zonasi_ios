//
//  ModuleFileCell.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 02/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class ModuleFileCell: UITableViewCell {

    @IBOutlet weak var file_image: UIImageView!
    @IBOutlet weak var file_name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configu re the view for the selected state
    }
    
}
