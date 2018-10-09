//
//  SearchLocationLastContentTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class SearchLocationLastContentTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var settingLocationLabel: UILabel!
    
    @IBOutlet weak var firstImageView: UIImageView!
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var firstStackView: UIStackView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    @IBOutlet weak var secondLabel: UILabel!
    @IBOutlet weak var secondStackView: UIStackView!
    
    @IBOutlet weak var thirdImageView: UIImageView!
    @IBOutlet weak var thirdLabel: UILabel!
    @IBOutlet weak var thirdStackView: UIStackView!
    
    @IBOutlet weak var fourthImageView: UIImageView!
    @IBOutlet weak var fourthLabel: UILabel!
    @IBOutlet weak var fourthStackView: UIStackView!
    
    @IBOutlet weak var fifthImageView: UIImageView!
    @IBOutlet weak var fifthLabel: UILabel!
    @IBOutlet weak var fifthStackView: UIStackView!
    
    @IBOutlet weak var sixthImageView: UIImageView!
    @IBOutlet weak var sixthLabel: UILabel!
    @IBOutlet weak var sixthStackView: UIStackView!
    
    @IBOutlet weak var seventhImageView: UIImageView!
    @IBOutlet weak var seventhLabel: UILabel!
    @IBOutlet weak var seventhStackView: UIStackView!
    
    lazy var network = NetworkManager()
    
    var count = 0
    var updateValue: [String] = []
    var location: VoteLocation? {
        didSet {
            guard let location = location else { return }
            count = 0
            updateValue = []
            
            titleLabel.text = "\(location.title)표소"
            settingLocationLabel.text = location.location
            addressLabel.text = location.address
            
            if location.toliet == "Y" {
                count = count + 1
                updateValue.append("toliet")
            }
            if location.bell == "Y" {
                count = count + 1
                updateValue.append("bell")
            }
            if location.elevator == "Y" {
                count = count + 1
                updateValue.append("elevator")
            }
            if location.pass == "Y" {
                count = count + 1
                updateValue.append("pass")
            }
            if location.block == "Y" {
                count = count + 1
                updateValue.append("block")
            }
            if location.slint == "Y" {
                count = count + 1
                updateValue.append("slint")
            }
            if location.lift == "Y" {
                count = count + 1
                updateValue.append("lift")
            }
            updateDisable()
        }
    }
    
    let items = ["toliet": ("장애인 화장실", #imageLiteral(resourceName: "imgD01")), "bell": ("도움벨", #imageLiteral(resourceName: "imgD06")), "elevator": ("승강기", #imageLiteral(resourceName: "imgD03")), "pass": ("장애인 통로", #imageLiteral(resourceName: "imgD02")),
                 "block": ("점자유도블럭", #imageLiteral(resourceName: "imgD04")), "slint": ("한국수어 통역사", #imageLiteral(resourceName: "imgD07")), "lift": ("휠체어 리프트", #imageLiteral(resourceName: "imgD05"))]
    
    private func updateDisable() {
        firstStackView.isHidden = true
        secondStackView.isHidden = true
        thirdStackView.isHidden = true
        fourthStackView.isHidden = true
        fifthStackView.isHidden = true
        sixthStackView.isHidden = true
        seventhStackView.isHidden = true
        
        for index in 0..<updateValue.count {
            switch index {
            case 0:
                firstStackView.isHidden = false
                firstLabel.text = items[updateValue[index]]!.0
                firstImageView.image = items[updateValue[index]]!.1
            case 1:
                secondStackView.isHidden = false
                secondLabel.text = items[updateValue[index]]!.0
                secondImageView.image = items[updateValue[index]]!.1
            case 2:
                thirdStackView.isHidden = false
                thirdLabel.text = items[updateValue[index]]!.0
                thirdImageView.image = items[updateValue[index]]!.1
            case 3:
                fourthStackView.isHidden = false
                fourthLabel.text = items[updateValue[index]]!.0
                fourthImageView.image = items[updateValue[index]]!.1
            case 4:
                fifthStackView.isHidden = false
                fifthLabel.text = items[updateValue[index]]!.0
                fifthImageView.image = items[updateValue[index]]!.1
            case 5:
                sixthStackView.isHidden = false
                sixthLabel.text = items[updateValue[index]]!.0
                sixthImageView.image = items[updateValue[index]]!.1
            case 6:
                seventhStackView.isHidden = false
                seventhLabel.text = items[updateValue[index]]!.0
                seventhImageView.image = items[updateValue[index]]!.1
            default:
                break
            }
        }
    }
    
    @IBAction func openApp(_ sender: UIButton) {
        guard let location = location else { return }
        network.getCoor(location.address) { result in
            guard let result = result else { return }
            self.openApp(sender.tag, x: result.posX, y: result.posY)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }
    
    private func openApp(_ type: Int, x: Double, y: Double) {
        switch type {
        case 0:
            guard let url = URL(string: "navermaps://?menu=location&pinType=place&lat=\(y)&lng=\(x)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case 1:
            guard let url = URL(string: "daummaps://look?p=\(y),\(x)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case 2:
            guard let url = URL(string: "http://maps.google.com/maps?q=\(y),\(x)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        case 3:
            guard let url = URL(string: "http://maps.apple.com/?q=\(y),\(x)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        default:
            break
        }
    }

}
