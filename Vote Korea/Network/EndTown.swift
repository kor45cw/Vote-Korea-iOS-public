//
//  EndTown.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 5..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import ObjectMapper

struct EndTown: Mappable {
    var sggName = ""
    var endName = ""
    var wiwId = 0
    var sdName = ""
    var sgName = ""
    var jungsu = 0
    var endId = 0
    var winName = ""
    var sgType = 0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        sggName <- map["SGGNAME"]
        endName <- map["EMDNAME"]
        wiwId <- map["WIWID"]
        sdName <- map["SDNAME"]
        sgName <- map["SGNAME"]
        jungsu <- map["JUNGSU"]
        endId <- map["EMDID"]
        winName <- map["WIWNAME"]
        sgType <- map["SGTYPE"]
    }
}
