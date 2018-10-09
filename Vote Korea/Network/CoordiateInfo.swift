//
//  CoordiateInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import ObjectMapper

struct CoordiateInfo: Mappable {
    var posX = 0.0
    var posY = 0.0
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        posX <- map["point.x"]
        posY <- map["point.y"]
    }
}
