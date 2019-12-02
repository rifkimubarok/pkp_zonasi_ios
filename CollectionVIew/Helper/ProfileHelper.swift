//
//  ProfileHelper.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 02/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import Foundation
import UIKit

struct jenjangObj : Decodable {
    let k_jenjang : Int?
    let keterangan : String?
}

struct sekolahObj : Decodable {
    let sekolah_id : Int?
    let nama : String?
    let alamat : String?
    let jenjang : jenjangObj?
}

struct kotaObj : Decodable {
    let k_kota : Int?
    let keterangan : String?
}

struct kecamatanObj : Decodable {
    let k_kecamatan : Int?
    let keterangan : String?
}

struct tglLahirObj : Decodable {
    let date : String?
    let timezone_type : Int?
    let timezone : String?
}

struct dataObj : Decodable {
    let no_ukg : String?
    let nuptk : String?
    let golongan : String?
    let tmp_lahir : String?
    let tgl_lahir : tglLahirObj?
    let kelamin : String?
    let kecamatan : kecamatanObj?
    let kota : kotaObj?
    let propinsi : kotaObj?
    let sekolah : sekolahObj?
}

struct profileObj : Decodable {
    let status : Bool
    let message : String?
    let status_code : String?
    let data : dataObj?
}

struct profileObj2 : Decodable {
    let id : Int?
    let username : String?
    let fullname : String?
    let email : String?
}

class ProfileHelper {

    let apiHelper = ApiHelper()
    
    func load_profile(token : String, no_ukg: String, completion: @escaping (_ status : Bool?, _ data : profileObj?)->()) {
        
        let url = "\(apiHelper.endPointApiSimpkn)\(no_ukg)?access_token=\(token)"
        let urlObj = URL(string: url)
        
        let task = URLSession.shared.dataTask(with: urlObj!) { (data, response, error) in
            if(error != nil){
                completion(false,nil)
                return
            }
            
            guard let data = data else {return}
            do{
                let json = try JSONDecoder().decode(profileObj.self, from: data)
                completion(true,json)
            }catch let jsonExcept {
                print("We Got Error ",jsonExcept)
                completion(false,nil)
            }
        }
        task.resume()
    }
    
    func load_profile_moodle(completion: @escaping (_ status : Bool?, _ data : profileObj2?)->()) {
        
        let token = UserDefaults.standard.string(forKey: "token")!
        var url : String = "\(apiHelper.EndPointAPI)webservice/rest/server.php?wstoken=\(token)&wsfunction=core_user_get_users_by_field&moodlewsrestformat=json&wsfunction=core_user_get_users_by_field&moodlewsrestformat=json"
        
        let username = UserDefaults.standard.string(forKey: "username")!.lowercased()
        if username.isValidEmail {
            url = url + "&field=email&values[0]=\(username)"
        }else{
            url = url + "&field=username&values[0]=\(username)"
        }
        print(url)
        let urlObj = URL(string: url)
        
        let profileTask = URLSession.shared.dataTask(with: urlObj!) { (data
            , response, error) in
            if(error != nil){
                completion(false,nil)
                return
            }
            guard let data = data else {return}
            do{
                let json = try JSONDecoder().decode([profileObj2].self, from: data)
                if json.count > 0 {
                    completion(true, json[0])
                }else{
                    completion(false,nil)
                }
                print(json)
                return
            }catch let jsonExp {
                print("We got somthing error ", jsonExp)
            }
        }
        profileTask.resume()
    }
}

extension String{
    var isValidEmail: Bool {
       let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
       let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
       return testEmail.evaluate(with: self)
    }
}
