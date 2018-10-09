//
//  SplashViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 17..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RxSwift

class SplashViewController: UIViewController {

    lazy var network = NetworkManager()
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UpdateChecker.run(self, updateType: .force) { [weak self] result in
            guard let self = self else { return }
            if !result { self.showMain() }
        }
    }
    
    private func showMain() {
        DispatchQueue.main.async {
            self.userDefaults.set(true, forKey: "isCode")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let destination = storyboard.instantiateViewController(withIdentifier: "main") as! UITabBarController
            destination.selectedIndex = 1
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else  { return }
            appDelegate.window?.rootViewController = destination
        }
    }
}
