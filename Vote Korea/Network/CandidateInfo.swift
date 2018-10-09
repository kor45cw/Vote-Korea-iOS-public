//
//  CandidateInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import XMLMapper
import RealmSwift
import ObjectMapper

class CandidateInfo: Object, XMLMappable{
    @objc dynamic var nodeName: String!
    
    @objc dynamic var sgTypecode = 0
    @objc dynamic var huboid = 0
    @objc dynamic var sggName = ""
    @objc dynamic var sdName = ""
    @objc dynamic var giho = 0
    @objc dynamic var jdName = ""
    @objc dynamic var name = ""
    @objc dynamic var hanjanName = ""
    @objc dynamic var gender = ""
    @objc dynamic var birthday = 0
    @objc dynamic var age = 0
    @objc dynamic var addr = ""
    @objc dynamic var status = ""
    @objc dynamic var imagePath = ""
    
    
    override static func primaryKey() -> String? {
        return "huboid"
    }

    required convenience init(map: XMLMap) {
        self.init()
    }
    
    func mapping(map: XMLMap) {
        sgTypecode <- map["sgTypecode"]
        huboid <- map["huboid"]
        sggName <- map["sggName"]
        sdName <- map["sdName"]
        giho <- map["giho"]
        jdName <- map["jdName"]
        name <- map["name"]
        hanjanName <- map["hanjaName"]
        gender <- map["gender"]
        birthday <- map["birthday"]
        age <- map["age"]
        addr <- map["addr"]
        status <- map["status"]
    }
}
