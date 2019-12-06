//
//  ApiHelper.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 19/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit
import Alamofire

struct keyAutoLogin : Decodable {
    let key : String?
    let autologinurl : String?
    let message : String?
}
class ApiHelper: NSObject {
    var EndPointAPI : String = "https://pkp.belajar.kemdikbud.go.id/"
//    var EndPointAPI : String = "http://223.27.153.196/"
    var ServiceAPI : String = "moodle_mobile_app";
    var urlforImage : String = "https://convertsvgpng.herokuapp.com/convert?url="
    var serviceTemp : String = "serviceAPIChacer";
    var EndPointTemp : String = "endAPIChacer";

    var default_token : String = "5ecb2df16c42f4618d75f1d3f580c2a3";
//    var default_token : String = "61a2fd383dd9fea306bfc80ea3a0ba61";
    
    // MARK: Token SIMPKB
    let endPointSimpkb : String = "https://oauth.simpkb.id/oauth/access_token";
    let endPointApiSimpkn : String = "https://gtk.belajar.kemdikbud.go.id/api/ptk/info/"
    let client_id : String = "gpogtk";
    let client_secret : String = "gtkgp0";
    let grant_type : String = "client_credentials";
    let scope : String = "read";
    
    
//    MARK: Token Auto Login
    func getTokenAutoLogin(completion: @escaping (_ status : Bool?, _ data : keyAutoLogin?)->()) {
        let session = URLSession.shared
        let token = UserDefaults.standard.string(forKey: "token") ?? ""
        let privatetoken = UserDefaults.standard.string(forKey: "privatetoken")
        let uri : String = "\(EndPointAPI)webservice/rest/server.php?wsfunction=tool_mobile_get_autologin_key&moodlewsrestformat=json&wstoken=\(token)"
        let url = URL(string: uri)!
        let parameters : Parameters =  ["privatetoken":privatetoken!]
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        do {
//            request.httpBody = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
//        } catch let error {
//            print(error.localizedDescription)
//        }
//        print("URL ",uri)
//        print(param)
        Alamofire.request(uri,method: .post,parameters: parameters).responseJSON { (response) in
            switch response.result {
            case .success:
                guard let data = response.data else {return}
                do{
                    let result = try JSONDecoder().decode(keyAutoLogin.self, from: data)
                    if result.message != nil {
                        completion(false,nil)
                        return
                    }
                    UserDefaults.standard.set(result.autologinurl!, forKey: "autologin")
                    UserDefaults.standard.set(result.key!, forKey: "keyLogin")
                    let currentDateTime = Date()
                    let date = currentDateTime.addingTimeInterval(TimeInterval(6.0 * 60.0))
                    let format = DateFormatter()
                    format.timeZone = TimeZone.current
                    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let localDateStr = format.string(from: date)
                    UserDefaults.standard.set(localDateStr, forKey: "expiredToken")
                    print("Hasil ",result)
                    completion(true,result)
                    return
                }catch let JsonErr {
                    completion(false,nil)
                    //error
                    print("We got error ",JsonErr)
                }
                
            case .failure(let error):

                print(error)
            }
        }
//        let task = session.dataTask(with: request) { data, response, error in
//            if error != nil {
//                completion(false,nil)
//                return
//            }
//
//            guard let data = data else {return}
//            do{
//                let result = try JSONDecoder().decode(keyAutoLogin.self, from: data)
//                UserDefaults.standard.set(result.autologinurl, forKey: "autologin")
//                UserDefaults.standard.set(result.key, forKey: "keyLogin")
//                let currentDateTime = Date()
//                let date = currentDateTime.addingTimeInterval(TimeInterval(6.0 * 60.0))
//                let format = DateFormatter()
//                format.timeZone = TimeZone.current
//                format.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                let localDateStr = format.string(from: date)
//                UserDefaults.standard.set(localDateStr, forKey: "expiredToken")
//                print("Hasil ",result)
//                print("Message ",result.message ?? "nothing")
//                completion(true,result)
//                return
//            }catch let JsonErr {
//                completion(false,nil)
//                print("We got error ",JsonErr)
//            }
//        }
//
//        task.resume()
    }
    
}
