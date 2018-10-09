//
//  PDFInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import ObjectMapper

struct PDFInfo: Mappable {
    var filePath = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        filePath <- map["FILEPATH"]
    }
}
