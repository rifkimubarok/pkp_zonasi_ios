//
//  ApiHelper.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 19/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class ApiHelper: NSObject {
//    var EndPointAPI : String = "https://pkp.belajar.kemdikbud.go.id/"
    var EndPointAPI : String = "http://223.27.153.196/"
    var ServiceAPI : String = "moodle_mobile_app";
    var urlforImage : String = "https://convertsvgpng.herokuapp.com/convert?url="
    var serviceTemp : String = "serviceAPIChacer";
    var EndPointTemp : String = "endAPIChacer";

//    var default_token : String = "099a8fd90660ed31991acc7c59d729f9";
    var default_token : String = "61a2fd383dd9fea306bfc80ea3a0ba61";
    
    // MARK: Token SIMPKB
    let endPointSimpkb : String = "https://oauth.simpkb.id/oauth/access_token";
    let endPointApiSimpkn : String = "https://gtk.belajar.kemdikbud.go.id/api/ptk/info/"
    let client_id : String = "gpogtk";
    let client_secret : String = "gtkgp0";
    let grant_type : String = "client_credentials";
    let scope : String = "read";
    
}
