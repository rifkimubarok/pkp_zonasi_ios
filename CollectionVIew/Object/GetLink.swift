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
    
    func fixedLink(text : String) -> String {
        var summaryText : String = text
        let token = UserDefaults.standard.string(forKey: "token")  ?? ""
        let result = self.matches(for: "(https?|ftp|file)://[-a-zA-Z0-9+&@#/%?=~_|!:,.;]*[-a-zA-Z0-9+&@#/%=~_|]", in: text)
        for item in result {
            let itemArr = item.split{$0 == "?"}.map(String.init)
            var url : String = "";
            if itemArr.count > 1 {
                url = itemArr[0] + "?" + itemArr[1] + "&token=" + token;
            }else{
                url = item + "?token=" + token;
            }
            summaryText = summaryText.replacingOccurrences(of: item, with: url)
        }
        return summaryText
    }
}
