//
//  SearchLocationMiddleViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class SearchLocationMiddleViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchText: String = ""
    lazy var network = NetworkManager()
    var result: [AddressInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        network.getAddress(searchText) { addressResults in
            if let items = addressResults {
                self.result = items
                self.tableView.reloadData()
            } else {
                self.network.getAddressRoad(self.searchText) { result in
                    if let items = result {
                        self.result = items
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toResult":
            let destination = segue.destination as! SearchLocationLastViewController
            if let sender = sender as? AddressInfo {
                destination.addressResult = sender
            }
        default:
            break
        }
    }
}

extension SearchLocationMiddleViewController: SearchInputChangeDelegate {
    func change(_ text: String) {
        self.searchText = text
    }
    
    func newSearch() {
        network.getAddress(searchText) { addressResults in
            if let items = addressResults {
                self.result = items
                self.tableView.reloadData()
            } else {
                self.network.getAddressRoad(self.searchText) { result in
                    if let items = result {
                        self.result = items
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func change(_ index: Int) {
    }
}

extension SearchLocationMiddleViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if result.isEmpty {
            return 2
        }
        return result.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! SaerchResultTableViewCell
            cell.type = 1
            cell.inputText = searchText
            cell.delegate = self
            cell.count = result.count
            return cell
        default:
            if result.isEmpty {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath)
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! AddressResultTableViewCell
            cell.type = 1
            cell.item = result[indexPath.row-1]
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row > 0 && !result.isEmpty {
            self.performSegue(withIdentifier: "toResult", sender: result[indexPath.row-1])
        }
    }
}

extension SearchLocationMiddleViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: self.view.convert(location, to: tableView)) else { return nil }
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "searchLast") as? SearchLocationLastViewController else { return nil }
        previewingContext.sourceRect = self.view.convert(tableView.rectForRow(at: indexPath), from: tableView)
        if indexPath.row > 0 && !result.isEmpty {
            destination.addressResult = result[indexPath.row-1]
            return destination
        } else {
            return nil
        }
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
