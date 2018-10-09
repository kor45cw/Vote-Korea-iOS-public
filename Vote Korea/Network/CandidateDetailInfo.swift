//
//  CandidateDetailInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class CandidateDetailInfo: Object, Mappable {
    @objc dynamic var imagePath = ""
    @objc dynamic var sggName = ""
    @objc dynamic var birthDay = ""
    @objc dynamic var jsuo = ""
    @objc dynamic var job = ""
    @objc dynamic var chenapIn5 = ""
    @objc dynamic var jaesan = ""
    @objc dynamic var millitary = ""
    @objc dynamic var huboid = 0
    @objc dynamic var giho = ""
    @objc dynamic var junkwasu = ""
    @objc dynamic var cuid = 0
    @objc dynamic var ihbCount = ""
    @objc dynamic var chenapAll = ""
    @objc dynamic var napse = ""
    @objc dynamic var age = ""
    @objc dynamic var gender = ""
    @objc dynamic var career1 = ""
    @objc dynamic var career2 = ""
    @objc dynamic var edu = ""
    
    override static func primaryKey() -> String? {
        return "huboid"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        imagePath <- map["SAJINPATH"]
        sggName <- map["SGGNAME"]
        birthDay <- map["BIRTHDAY"]
        jsuo <- map["JUSO"]
        job <- map["JIKUP"]
        chenapIn5 <- map["CHENAP"]
        jaesan <- map["JAESAN"]
        millitary <- map["BYUNGYUK"]
        huboid <- map["HUBOID"]
        giho <- map["GIHO"]
        cuid <- map["CUID"]
        junkwasu <- map["JUNKWASU"]
        ihbCount <- map["IHBCNT"]
        chenapAll <- map["CHENAP2"]
        napse <- map["NAPSE"]
        age <- map["AGE"]
        gender <- map["GENDER"]
        career1 <- map["KYUNGRUK"]
        career2 <- map["KYUNGRUK2"]
        edu <- map["HAKRUK"]
    }
}
