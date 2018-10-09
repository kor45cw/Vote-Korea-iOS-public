//
//  SettingInAppViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 19..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import StoreKit

class SettingInAppViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var products = [SKProduct]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(handlePurchaseNotification(_:)),
                                               name: NSNotification.Name(rawValue: IAPHelper.IAPHelperPurchaseNotification),
                                               object: nil)
        
        IAProduct.store.requestProducts { success, products in
            if success {
                self.products = products!.sorted(by: {
                    $0.price.compare($1.price) == .orderedAscending
                })
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func handlePurchaseNotification(_ notification: Notification) {
        let alertController = UIAlertController(title: "구매해 주셔서 감사합니다", message: nil, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "닫기", style: .default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
}

extension SettingInAppViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as! SettingInAppTableViewCell
        cell.row = indexPath.row
        if products.count > indexPath.row {
            cell.product = products[indexPath.row]
        }
        return cell
    }
}
