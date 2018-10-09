//
//  SearchLocationLastHeaderTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class SearchLocationLastHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    var address: AddressInfo? {
        didSet {
            guard let address = address else { return }
            var changeText = ElectionInfo.matchCity(address.region_1depth_name)
            if address.region_2depth_name != "" {
                changeText = "\(changeText) \(address.region_2depth_name)"
            }
            if address.region_3depth_name != "" {
                changeText = "\(changeText) \(address.region_3depth_name)"
            }
            let fullText = "\(changeText)의\n투표소를 확인하세요."
            titleLabel.halfTextColorChange(fullText: fullText, changeText: changeText, fontSize: 19)
        }
    }
}
