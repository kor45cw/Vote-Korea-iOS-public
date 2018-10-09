//
//  FavoriteData.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 1..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteData: Object {
    @objc dynamic var type = 0
    @objc dynamic var huboid = 0
    @objc dynamic var region_1depth_name = ""
    @objc dynamic var region_2depth_name = ""
    @objc dynamic var region_3depth_name = ""
    
    func setData(_ address: AddressInfo) {
        self.type = 0
        self.region_1depth_name = address.region_1depth_name
        self.region_2depth_name = address.region_2depth_name
        self.region_3depth_name = address.region_3depth_name
    }
    
    func setHubo(_ huboid: Int) {
        self.type = 1
        self.huboid = huboid
    }
}
