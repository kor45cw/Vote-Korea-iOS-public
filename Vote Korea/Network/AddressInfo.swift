//
//  AddressInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 23..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import ObjectMapper

struct AddressInfo: Mappable {
    var region_1depth_name = ""
    var region_2depth_name = ""
    var region_3depth_name = ""
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {        
        region_1depth_name <- map["region_1depth_name"]
        region_2depth_name <- map["region_2depth_name"]
        region_3depth_name <- map["region_3depth_name"]
        
        if region_3depth_name.isEmpty {
            region_3depth_name <- map["region_3depth_h_name"]
        }
    }
}

extension AddressInfo: Equatable {
    static func == (lhs: AddressInfo, rhs: AddressInfo) -> Bool {
        return lhs.region_1depth_name == rhs.region_1depth_name &&
            lhs.region_2depth_name == rhs.region_2depth_name && lhs.region_3depth_name == rhs.region_3depth_name
    }
}

extension Array {
    func uniqueValues<V:Equatable>(value: (Element)->V) -> [Element] {
        var result:[Element] = []
        for element in self {
            if !result.contains { value($0) == value(element) } {
                result.append(element)
            }
        }
        return result
    }
}
