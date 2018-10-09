//
//  SettingInAppTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 19..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import StoreKit

class SettingInAppTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var inappButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inappButton.isEnabled = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        inappButton.isEnabled = false
    }
    
    var product: SKProduct? {
        didSet {
            guard let product = product else { return }
            if IAPHelper.canMakePayments() {
                inappButton.setTitle(product.localizedPrice(), for: .normal)
                inappButton.isEnabled = true
            }
        }
    }
    
    var row: Int? {
        didSet {
            guard let row = row else { return }
            switch row {
            case 0:
                titleLabel.text = "유익한 앱을 위해 후원해주세요."
                subtitleLabel.text = "기획 분야"
                inappButton.setTitle("$ 0.99", for: .normal)
            case 1:
                titleLabel.text = "안정된 앱을 위해 후원해주세요."
                subtitleLabel.text = "SW 개발 분야"
                inappButton.setTitle("$ 2.99", for: .normal)
            case 2:
                titleLabel.text = "아름다운 앱을 위해 후원해주세요."
                subtitleLabel.text = "UI 디자인 분야"
                inappButton.setTitle("$ 9.99", for: .normal)
            case 3:
                titleLabel.text = "편리한 앱을 위해 후원해주세요."
                subtitleLabel.text = "UX 디자인 분야"
                inappButton.setTitle("$ 99.99", for: .normal)
            default:
                break
            }
        }
    }
    
    @IBAction func buyAction(_ sender: UIButton) {
        guard let product = product else { return }
        IAProduct.store.buyProduct(product)
    }
}

extension SKProduct {
    func localizedPrice() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = self.priceLocale
        return formatter.string(from: self.price)!
    }
}
