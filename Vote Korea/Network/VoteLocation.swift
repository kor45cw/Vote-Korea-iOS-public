//
//  VoteLocation.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import ObjectMapper

struct VoteLocation: Mappable {
    var toliet = "N"
    var endName = ""
    var bell = "N"
    var elevator = "N"
    var pass = "N"
    var block = "N"
    var address = ""
    var tel = ""
    var sdName = ""
    var title = ""
    var location = ""
    var wiwname = ""
    var slint = "N"
    var lift = "N"
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        toliet <- map["D_TOILET"]
        endName <- map["EMDNAME"]
        bell <- map["BELL"]
        elevator <- map["ELEVATOR"]
        pass <- map["D_PASS"]
        block <- map["B_BLOCK"]
        address <- map["BTJUSO"]
        tel <- map["BTJUSO"]
        sdName <- map["SDNAME"]
        title <- map["BTTUSONAME"]
        location <- map["BTJANGSO"]
        wiwname <- map["WIWNAME"]
        slint <- map["KORSLINT"]
        lift <- map["W_LIFT"]
        
        location <- map["BDNAME"]
        address <- map["TPSJUSO"]
        title <- map["TPGNAME"]
    }
}
