//
//  AddressResultTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 23..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift

class AddressResultTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    
    let realm = try! Realm()
    var results: Results<FavoriteData>?
    
    var favoriteItem: FavoriteData? {
        didSet {
            guard let favorite = favoriteItem else { return }
            item = AddressInfo(JSON: ["region_1depth_name": favorite.region_1depth_name,
                                      "region_2depth_name": favorite.region_2depth_name,
                                      "region_3depth_name": favorite.region_3depth_name])
        }
    }
    
    var type = 0
    var item: AddressInfo? {
        didSet {
            guard let item = item else { return }
            if type == 0 {
                let predicate = NSPredicate(format: "region_1depth_name == %@ AND region_2depth_name == %@ AND region_3depth_name == %@",item.region_1depth_name, item.region_2depth_name, item.region_3depth_name)
                results = realm.objects(FavoriteData.self).filter(predicate)
                starButton.isSelected = results?.first != nil
            }
            
            var fullText = ElectionInfo.matchCity(item.region_1depth_name)
            var changeText = ElectionInfo.matchCity(item.region_1depth_name)
            if item.region_2depth_name != "" {
                fullText = "\(fullText) > \(item.region_2depth_name)"
                changeText = item.region_2depth_name
            }
            if item.region_3depth_name != "" {
                fullText = "\(fullText) > \(item.region_3depth_name)"
                changeText = item.region_3depth_name
            }
            titleLabel.halfTextColorChange(fullText: fullText, changeText: changeText, fontName: "YiSunShinDotumB", fontSize: 15)
            
        }
    }
    
    
    @IBAction func starClick(_ sender: UIButton) {
        if let item = item {
            let predicate = NSPredicate(format: "region_1depth_name == %@ AND region_2depth_name == %@ AND region_3depth_name == %@",item.region_1depth_name, item.region_2depth_name, item.region_3depth_name)
            results = realm.objects(FavoriteData.self).filter(predicate)
            try! realm.write {
                if sender.isSelected {
                    if let result = results {
                        realm.delete(result)
                        sender.isSelected = false
                    }
                } else {
                    let newItem = realm.create(FavoriteData.self)
                    newItem.setData(item)
                    realm.add(newItem)
                    sender.isSelected = true
                }
            }
        }
    }
    
}
