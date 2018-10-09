//
//  SggCode.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import XMLMapper


struct SggCode: XMLMappable {
    var nodeName: String!
    
    var sggJungsu = 0
    var sggName = ""
    var sdName = ""
    
    init(map: XMLMap) {}
    
    mutating func mapping(map: XMLMap) {
        sggJungsu <- map["sggJungsu"]
        sggName <- map["sggName"]
        sdName <- map["sdName"]
    }
}
