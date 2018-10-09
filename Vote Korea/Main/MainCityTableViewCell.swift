//
//  MainCityTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 17..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class MainCityTableViewCell: UITableViewCell {
    @IBOutlet var buttons: Array<UIButton>!
    
    var item: [String]? {
        didSet {
            guard let items = item else { return }
            for index in 0..<items.count {
                buttons[index].isUserInteractionEnabled = true
                buttons[index].setTitle(items[index], for: .normal)
                buttons[index].backgroundColor = .buttonBackground
            }
            
            for index in items.count..<buttons.count {
                buttons[index].isUserInteractionEnabled = false
                buttons[index].setTitle("", for: .normal)
                buttons[index].backgroundColor = .clear
            }
        }
    }
}
