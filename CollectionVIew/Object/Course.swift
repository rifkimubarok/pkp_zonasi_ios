//
//  Course.swift
//  CollectionVIew
//
//  Created by Rifki Mubarok on 18/11/19.
//  Copyright © 2019 Dirjen GTK Kemdikbud-DIKTI. All rights reserved.
//

import UIKit

class Course: NSObject {
    var course_id : String
    var course_name : String
    var imagename : String

    init(course_id: String, course_name: String, imagename: String) {
        self.course_id = course_id
        self.course_name = course_name
        self.imagename = imagename
    }
}

struct moduleObj : Decodable {
    let id : Int
    let name : String
    let instance : Int
    let url : String?
//    let description : String 
    let modicon : String
    let modname : String
    let indent : Int
}


struct sectionObj : Decodable {
    let id : Int
    let name : String
    let visible : Int
    let summary : String
    let summaryformat : Int
    let section : Int
    let hiddenbynumsections : Int
    let modules : [moduleObj]
}

struct sectionArr : Decodable {
    let course : [sectionObj]
}
