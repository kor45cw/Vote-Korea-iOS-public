//
//  CityInfo.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import RealmSwift
import ObjectMapper

class CityInfo: Object, Mappable {
    @objc dynamic var CODE = 0
    @objc dynamic var NAME = ""
    
    override static func primaryKey() -> String? {
        return "CODE"
    }
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        CODE <- (map["CODE"], IntTransform())
        NAME <- map["NAME"]
    }
}

public class IntTransform: TransformType {
    
    public typealias Object = Int
    public typealias JSON = Any?
    
    public init() {}
    
    public func transformFromJSON(_ value: Any?) -> Int? {
        
        var result: Int?
        
        guard let json = value else {
            return result
        }
        
        if json is Int {
            result = (json as! Int)
        }
        if json is String {
            result = Int(json as! String)
        }
        
        return result
    }
    
    public func transformToJSON(_ value: Int?) -> Any?? {
        
        guard let object = value else {
            return nil
        }
        
        return String(object)
    }
}
