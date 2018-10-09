//
//  SettingTeamInfoViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 19..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import MessageUI

class SettingTeamInfoViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var firstView: UIView!
    @IBOutlet weak var secondView: UIView!
    @IBOutlet weak var thirdView: UIView!
    @IBOutlet weak var fourthView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstGesture = UITapGestureRecognizer(target: self, action: #selector(sendMail(_:)))
        firstView.addGestureRecognizer(firstGesture)
        
        let secondGesture = UITapGestureRecognizer(target: self, action: #selector(sendMail(_:)))
        secondView.addGestureRecognizer(secondGesture)
        
        let thirdGesture = UITapGestureRecognizer(target: self, action: #selector(sendMail(_:)))
        thirdView.addGestureRecognizer(thirdGesture)
        
        let fourthGesture = UITapGestureRecognizer(target: self, action: #selector(sendMail(_:)))
        fourthView.addGestureRecognizer(fourthGesture)
    }
    
    
    
    @objc func sendMail(_ sender: UITapGestureRecognizer) {
        guard let sender = sender.view else { return }
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = configuredMailComposeViewController(sender.tag)
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert(sender.tag)
        }
    }
    
    func configuredMailComposeViewController(_ type: Int) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        
        switch type {
        case 0:
            mailComposerVC.setToRecipients(["kor45cw@gmail.com"])
        case 1:
            mailComposerVC.setToRecipients(["habong8879@naver.com"])
        case 2:
            mailComposerVC.setToRecipients(["000020.design@gmail.com"])
        case 4:
            mailComposerVC.setToRecipients(["manekinekodev@gmail.com"])
        default:
            break
        }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert(_ type: Int) {
        var url: URL? = nil
        
        switch type {
        case 0:
            url = URL(string: "http://pf.kakao.com/_xaPxkxau")
        case 2:
            url = URL(string: "http://plus.kakao.com/home/@0x0020")
        case 4:
            url = URL(string: "http://pf.kakao.com/_Sxhdjxl")
        default:
            break
        }
        if let url = url, UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:])
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}
