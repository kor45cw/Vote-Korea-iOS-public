//
//  MainSettingTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 19..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class MainSettingTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    
    var row: Int? {
        didSet {
            guard let row = row else { return }
            switch row {
            case 0:
                titleLabel.text = "알림설정"
            case 1:
                titleLabel.text = "마네키네코 팀 소개"
            case 2:
                titleLabel.text = "후원하기"
            case 3:
                titleLabel.text = "오류 문의"
            case 4:
                titleLabel.text = "OPEN SOURCE LIBRARY"
            default:
                break
            }
        }
    }
}
