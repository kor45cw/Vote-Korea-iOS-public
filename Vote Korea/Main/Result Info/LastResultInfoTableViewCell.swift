//
//  LastResultInfoTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift

class LastResultInfoTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var subcontentLabel: UILabel!
    @IBOutlet weak var imageButton: UIButton!
    
    let titles = ["기호", "생년월일", "성별", "주소", "직업",
                  "경력", "학력", "재산신고액", "납부액", "병역신고사항",
                  "최근 5년 체납액", "현체납액", "전과기록", "입후보 횟수"]
    
    let yourAttributes : [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.font : UIFont(name: "YiSunShinDotumM", size: 13)!,
        NSAttributedString.Key.foregroundColor : UIColor.buttonClick,
        NSAttributedString.Key.underlineStyle : NSUnderlineStyle.single.rawValue]
    
    var delegate: PDFDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var currentIndex = 0
    var electionCode = 0
    var row: Int? {
        didSet {
            guard let row = row else { return }
            if electionCode == 10 || electionCode == 11 {
                typeLabel.text = titles[row]
            } else {
                typeLabel.text = titles[row - 1]
            }
        }
    }
    
    @IBAction func click(_ sender: UIButton) {
        guard let datas = datas else { return }
        delegate?.click((datas[currentIndex].huboid, sender.tag))
    }
    
    var datas: Results<CandidateInfo>?
    var detailDatas: [CandidateDetailInfo]? {
        didSet {
            guard let detailDatas = detailDatas, let datas = datas, var row = row, let item = detailDatas.filter({ $0.huboid == datas[currentIndex].huboid}).first else { return }
            if electionCode == 10 || electionCode == 11 {
                row = row + 1
            }
            switch row {
            case 1:
                contentLabel.text = item.giho
            case 2:
                contentLabel.halfTextColorChange(fullText: "\(item.age)세 (\(item.birthDay))", changeText: "(\(item.birthDay))", fontSize: 11)
            case 3:
                contentLabel.text = item.gender == "남" ? "남자" : "여자"
            case 4:
                contentLabel.text = item.jsuo
            case 5:
                contentLabel.text = item.job
            case 6:
                contentLabel.text = item.career1
                subcontentLabel.text = item.career2
            case 7:
                contentLabel.text = item.edu
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 1
            case 8:
                contentLabel.text = "\(item.jaesan) 천원"
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 2
            case 9:
                contentLabel.text = "\(item.napse) 천원"
            case 10:
                contentLabel.text = item.millitary
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 4
            case 11:
                contentLabel.text = "\(item.chenapIn5) 천원"
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 3
            case 12:
                contentLabel.text = "\(item.chenapAll) 천원"
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 3
            case 13:
                contentLabel.text = item.junkwasu
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 5
            case 14:
                contentLabel.text = item.ihbCount
                let termsString = NSMutableAttributedString(string: "증명서 보기", attributes: yourAttributes)
                imageButton.setAttributedTitle(termsString, for: .normal)
                imageButton.tag = 8
            default:
                break
            }
        }
    }
}
