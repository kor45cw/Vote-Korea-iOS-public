//
//  WarningCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class WarningCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    
    var titleText: String? {
        didSet {
            guard let titleText = titleText else { return }
            titleLabel.text = titleText
        }
    }
}
