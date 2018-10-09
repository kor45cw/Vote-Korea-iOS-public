//
//  LastResultHeaderTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift

class LastResultHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var typeTitleLabel: UILabel!
    @IBOutlet weak var electionTypeLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var totalCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    var electionCode = 0
    var sggJungsu = 0
    var datas: Results<CandidateInfo>? {
        didSet {
            guard let datas = datas, let item = datas.first else { return }
            cityLabel.text = item.sdName
            let cityInfo = item.sdName == item.sggName ? item.sdName : "\(item.sdName) \(item.sggName)"
            let changeText = "\(cityInfo) \(ElectionInfo.findName(electionCode))"
            let fullText = "\(changeText)의\n후보자를 확인하세요."
            typeTitleLabel.halfTextColorChange(fullText: fullText, changeText: changeText, fontSize: 19)
            totalCount.text = "(후보자 : \(datas.count)명, 선출정수 : \((sggJungsu == 0) ? "-" : "\(sggJungsu)")명)"
        }
    }

}
