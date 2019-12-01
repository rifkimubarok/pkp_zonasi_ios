//
//  GetLink.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 01/12/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import Foundation
import UIKit

class GetLink {
    struct link {
        let url : String
    }
    
    var arrLink : [link] = []
    
    func matches(for regex: String, in text: String) -> [String] {

        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: text,
                                        range: NSRange(text.startIndex..., in: text))
            return results.map {
                String(text[Range($0.range, in: text)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
