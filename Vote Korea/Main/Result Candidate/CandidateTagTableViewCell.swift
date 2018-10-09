//
//  CandidateTagTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit



class CandidateTagTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeightConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    var delegate: SearchInputChangeDelegate?
    
    var index: Int = 0
    
    var items: [Int: Int]? {
        didSet {
            guard let _ = items else { return }
            collectionView.reloadData()
        }
    }
    
    
}

extension CandidateTagTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var text = "전체"
        guard let items = items else { return CGSize.zero }
        if indexPath.row == 0 {
            let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
            return CGSize(width: size.width + 30, height: 32.0)
        }
        
        let key = Array(items.keys.sorted())[indexPath.row-1]
        switch key {
        case 3:
            text = "시·도지사선거 \(items[3]!)"
        case 4:
            text = "구·시·군의 장선거 \(items[4]!)"
        case 5:
            text = "시·도의회의원선거 \(items[5]!)"
        case 6:
            text = "구·시·군의회의원선거 \(items[6]!)"
        case 11:
            text = "교육감선거 \(items[11]!)"
        case 10:
            text = "교육의원선거 \(items[10]!)"
        case 2:
            text = "국회의원선거 \(items[2]!)"
        default:
            break
        }
        let size: CGSize = text.size(withAttributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
        return CGSize(width: size.width + 30, height: 32.0)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let items = items {
            return items.keys.count + 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    // 한줄에서의 셀 사이 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //  줄 사이 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var text = "전체"
        guard let items = items else { return UICollectionViewCell() }
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CandidateTagCell
            cell.tagButton.tag = 0
            cell.tagButton.addTarget(self, action: #selector(tagClick(_:)), for: .touchUpInside)
            cell.tagButton.isSelected = 0 == index
            cell.tagButton.backgroundColor = 0 == index ? .defaultBlack : .buttonBackground
            cell.tagButton.setTitle(text, for: .normal)
            return cell
        }
        let key = Array(items.keys.sorted())[indexPath.row-1]
        switch key {
        case 3:
            text = "시·도지사선거 \(items[3]!)"
        case 4:
            text = "구·시·군의 장선거 \(items[4]!)"
        case 5:
            text = "시·도의회의원선거 \(items[5]!)"
        case 6:
            text = "구·시·군의회의원선거 \(items[6]!)"
        case 11:
            text = "교육감선거 \(items[11]!)"
        case 10:
            text = "교육의원선거 \(items[10]!)"
        case 2:
            text = "국회의원선거 \(items[2]!)"
        default:
            break
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CandidateTagCell
        cell.tagButton.tag = key
        cell.tagButton.addTarget(self, action: #selector(tagClick(_:)), for: .touchUpInside)
        cell.tagButton.isSelected = key == index
        cell.tagButton.backgroundColor = key == index ? .defaultBlack : .buttonBackground
        cell.tagButton.setTitle(text, for: .normal)
        return cell
    }
    
    @objc func tagClick(_ sender: UIButton) {
        index = sender.tag
        delegate?.change(index)
    }
}
