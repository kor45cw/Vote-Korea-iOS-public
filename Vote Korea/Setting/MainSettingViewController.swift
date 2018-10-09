//
//  MainSettingViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 19..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import CTFeedbackSwift
import MessageUI
import AcknowList

class MainSettingViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Version \(version)"
        }
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
    }
}

extension MainSettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! MainSettingTableViewCell
        cell.row = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            self.performSegue(withIdentifier: "toAlarm", sender: self)
        case 1:
            self.performSegue(withIdentifier: "toTeamInfo", sender: self)
        case 2:
            self.performSegue(withIdentifier: "toInApp", sender: self)
        case 3:
            if MFMailComposeViewController.canSendMail() {
                let configuration = FeedbackConfiguration(toRecipients: ["manekinekodev@gmail.com"], hidesUserEmailCell: false, usesHTML: false)
                let controller    = FeedbackViewController(configuration: configuration)
                navigationController?.pushViewController(controller, animated: true)
            } else {
                let url = URL(string: "http://pf.kakao.com/_Sxhdjxl")
                if let url = url, UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:])
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        case 4:
            let viewController = AcknowListViewController()
            if let navigationController = self.navigationController {
                navigationController.pushViewController(viewController, animated: true)
            }
        default:
            break
        }
    }
}

extension MainSettingViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: self.view.convert(location, to: tableView)) else { return nil }
        previewingContext.sourceRect = self.view.convert(tableView.rectForRow(at: indexPath), from: tableView)
        
        switch indexPath.row {
        case 0:
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "alarm") as? SettingAlarmViewController else { return nil }
            return destination
        case 1:
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "team") as? SettingTeamInfoViewController else { return nil }
            return destination
        case 2:
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "inapp") as? SettingInAppViewController else { return nil }
            return destination
        case 3:
            if MFMailComposeViewController.canSendMail() {
                let configuration = FeedbackConfiguration(toRecipients: ["manekinekodev@gmail.com"], hidesUserEmailCell: false, usesHTML: false)
                let controller    = FeedbackViewController(configuration: configuration)
                return controller
            }
        case 4:
            return AcknowListViewController()
        default:
            return nil
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

