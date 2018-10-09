//
//  CandidateResultTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift
import Kingfisher

class CandidateResultTableViewCell: UITableViewCell {

    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var kNameLabel: UILabel!
    @IBOutlet weak var hNameLabel: UILabel!
    @IBOutlet weak var partyLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    lazy var network = NetworkManager()
    let realm = try! Realm()
    var results: Results<FavoriteData>?
    
    var key: Int? {
        didSet {
            guard let key = key else { return }
            titleLabel.text = ElectionInfo.findName(key)
        }
    }
    
    var huboid: Int? {
        didSet {
            guard let huboid = huboid else { return }
            let predicate = NSPredicate(format: "huboid == \(huboid)")
            item = realm.objects(CandidateInfo.self).filter(predicate).first
        }
    }
    
    var item: CandidateInfo? {
        didSet {
            guard let item = item else { return }
            let predicate = NSPredicate(format: "huboid == \(item.huboid)")
            results = realm.objects(FavoriteData.self).filter(predicate)
            favoriteButton.isSelected = results?.first != nil

            if item.imagePath == "" {
                network.getCandidateDetail(item.huboid) { result in
                    guard let result = result else { return }
                    self.thumbnailImageView.kf.setImage(with: URL(string: "http://info.nec.go.kr/photo_20180613\(result.imagePath)"))
                }
            } else {
                self.thumbnailImageView.kf.setImage(with: URL(string: "http://info.nec.go.kr/photo_20180613\(item.imagePath)"))
            }
            thumbnailImageView.layer.borderWidth = 2
            thumbnailImageView.layer.masksToBounds = false
            thumbnailImageView.layer.borderColor = UIColor.defaultBlack.cgColor
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
            thumbnailImageView.clipsToBounds = true
            kNameLabel.text = item.name
            hNameLabel.text = item.hanjanName
            partyLabel.text = item.jdName
            
            let changeName = item.sdName == item.sggName ? item.sggName : "\(item.sdName) > \(item.sggName)"
            descriptionLabel.halfTextColorChange(fullText: "\(ElectionInfo.findName(item.sgTypecode)) > \(changeName)", changeText: item.sggName)
        }
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        guard let item = item else { return }
        let predicate = NSPredicate(format: "huboid == \(item.huboid)")
        results = realm.objects(FavoriteData.self).filter(predicate)
        try! realm.write {
            if sender.isSelected {
                if let result = results {
                    realm.delete(result)
                    sender.isSelected = false
                }
            } else {
                let newItem = realm.create(FavoriteData.self)
                newItem.setHubo(item.huboid)
                realm.add(newItem)
                sender.isSelected = true
            }
        }
    }
}
