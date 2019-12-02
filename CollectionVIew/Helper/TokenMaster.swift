//
//  TokenMaster.swift
//  CollectionVIew
//
//  Created by Kiki Supendi on 02/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import Foundation
import UIKit

struct tokenSimpkb : Decodable {
    let access_token : String
    let token_type : String
    let expires_in : Int
}

class TokenMaster {
    var apiHelper = ApiHelper()
    
    func requestToken(completion: @escaping (_ status : Bool?)->()) {
        let url = apiHelper.endPointSimpkb + "?client_id=\(apiHelper.client_id)&client_secret=\(apiHelper.client_secret)&grant_type=\(apiHelper.grant_type)&scope=\(apiHelper.scope)"
        
        let urlReq = URL(string: url)!
        
        DispatchQueue.main.async {
            let request = URLSession.shared.dataTask(with: urlReq) { (data, response, error) in
                print("ini harusnya print terlebih dahulu")
                if error != nil {
                    print("Something wrong happen")
                    completion(false)
                    return
                }
                guard let data = data else {return}
                do {
                    let json = try JSONDecoder().decode(tokenSimpkb.self, from: data)
                    
                    let token = json.access_token
                    print(token)
                    UserDefaults.standard.set(token, forKey: "tokenSimpkb")
                    completion(true)
                    return
                }catch let jsonExp{
                    print("we got an error ",jsonExp)
                    completion(false)
                }
                
            }
            request.resume()
        }
    }
}
