//
//  SettingAlarmViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 19..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class SettingAlarmViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var alarmSwitch: UISwitch!
    
    lazy var userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIApplication.shared.isRegisteredForRemoteNotifications {
            titleLabel.text = "알림"
            titleLabel.textColor = .defaultBlack
            alarmSwitch.isOn = true
        } else {
            titleLabel.text = "받지않음"
            titleLabel.textColor = .disable
            alarmSwitch.isOn = false
        }
    }
    
    @IBAction func change(_ sender: UISwitch) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if sender.isOn {
            appDelegate.registerNotification()
            titleLabel.text = "알림"
            titleLabel.textColor = .defaultBlack
        } else {
            appDelegate.deregisterRemoteNotification()
            titleLabel.text = "받지않음"
            titleLabel.textColor = .disable
        }
    }
}
