//
//  LastResultMainTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift

class LastResultMainTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var jdNameLabel: UILabel!
    @IBOutlet weak var kNameLabel: UILabel!
    @IBOutlet weak var hNameLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    let realm = try! Realm()
    var results: Results<FavoriteData>?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var delegate: PDFDelegate? = nil
    var currentIndex = 0
    var datas: Results<CandidateInfo>? {
        didSet {
            guard let datas = datas else { return }
            pageControl.numberOfPages = datas.count
            pageControl.currentPage = currentIndex
            jdNameLabel.text = datas[currentIndex].jdName
            kNameLabel.text = datas[currentIndex].name
            hNameLabel.text = "(\(datas[currentIndex].hanjanName))"
            
            let predicate = NSPredicate(format: "huboid == \(datas[currentIndex].huboid)")
            results = realm.objects(FavoriteData.self).filter(predicate)
            favoriteButton.isSelected = results?.first != nil
        }
    }
    var detailDatas: [CandidateDetailInfo]? {
        didSet {
            guard let detailDatas = detailDatas, let datas = datas, let item = detailDatas.filter({ $0.huboid == datas[currentIndex].huboid}).first else { return }
            
            thumbnailImageView.kf.setImage(with: URL(string: "http://info.nec.go.kr/photo_20180613\(item.imagePath)"))
            thumbnailImageView.layer.borderWidth = 2
            thumbnailImageView.layer.masksToBounds = false
            thumbnailImageView.layer.borderColor = UIColor.defaultBlack.cgColor
            thumbnailImageView.layer.cornerRadius = thumbnailImageView.frame.height / 2
            thumbnailImageView.clipsToBounds = true
        }
    }
    
    @IBAction func showGongYak(_ sender: UIButton) {
        guard let datas = datas else { return }
        delegate?.click((datas[currentIndex].huboid, -1))
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        guard let datas = datas else { return }
        let predicate = NSPredicate(format: "huboid == \(datas[currentIndex].huboid)")
        results = realm.objects(FavoriteData.self).filter(predicate)
        try! realm.write {
            if sender.isSelected {
                if let result = results {
                    realm.delete(result)
                    sender.isSelected = false
                }
            } else {
                let newItem = realm.create(FavoriteData.self)
                newItem.setHubo(datas[currentIndex].huboid)
                realm.add(newItem)
                sender.isSelected = true
            }
        }
    }
    
}
