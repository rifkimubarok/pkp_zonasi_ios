//
//  ApiHelper.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 19/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
struct keyAutoLogin : Decodable {
    let key : String?
    let autologinurl : String?
}
class ApiHelper: NSObject {
//    var EndPointAPI : String = "https://pkp.belajar.kemdikbud.go.id/"
    var EndPointAPI : String = "http://223.27.153.196/"
    var ServiceAPI : String = "moodle_mobile_app";
    var urlforImage : String = "https://convertsvgpng.herokuapp.com/convert?url="
    var serviceTemp : String = "serviceAPIChacer";
    var EndPointTemp : String = "endAPIChacer";

//    var default_token : String = "5ecb2df16c42f4618d75f1d3f580c2a3";
    var default_token : String = "61a2fd383dd9fea306bfc80ea3a0ba61";
    
    // MARK: Token SIMPKB
    let endPointSimpkb : String = "https://oauth.simpkb.id/oauth/access_token";
    let endPointApiSimpkn : String = "https://gtk.belajar.kemdikbud.go.id/api/ptk/info/"
    let client_id : String = "gpogtk";
    let client_secret : String = "gtkgp0";
    let grant_type : String = "client_credentials";
    let scope : String = "read";
    
    func getTokenAutoLogin() {
        let a = "https://pkp.belajar.kemdikbud.go.id/webservice/rest/server.php?wsfunction=tool_mobile_get_autologin_key&moodlewsrestformat=json&wstoken=7d88f2bbc9466975c57a4e672f157f6b"
        let session = URLSession.shared
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let privatetoken = UserDefaults.standard.string(forKey: "privatetoken")
        let uri : String = "\(EndPointAPI)webservice/rest/server.php?wsfunction=tool_mobile_get_autologin_key&moodlewsrestformat=json&wstoken=\(token)"
        let url = URL(string: uri)!
        let param = ["privatetoken":privatetoken]
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
    }
    
}
