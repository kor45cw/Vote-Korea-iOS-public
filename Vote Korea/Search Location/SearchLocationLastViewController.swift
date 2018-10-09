//
//  SearchLocationLastViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class SearchLocationLastViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    
    var addressResult: AddressInfo?
    var locations: [VoteLocation] = []
    lazy var network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        guard let address = addressResult else { return }
        network.getVoteLocationDday(ElectionInfo.matchCity(address.region_1depth_name)) { (locations) in
            guard let locations = locations else { return }
            self.locations = locations
            if !address.region_2depth_name.isEmpty {
                let tempResult = self.locations.filter { $0.endName.contains(address.region_2depth_name) || $0.wiwname.contains(address.region_2depth_name) || $0.address.contains(address.region_2depth_name)}
                if !tempResult.isEmpty { self.locations = tempResult }
            }
            if !address.region_3depth_name.isEmpty {
                var tempResult = self.locations
                let inputString = String(address.region_3depth_name.replacingOccurrences(of: ".", with: "").split(separator: " ").first!)
                for index in 0..<inputString.count {
                    tempResult = tempResult.filter({ $0.title.contains(inputString[index]) })
                }
                if !tempResult.isEmpty { self.locations = tempResult }
                else { self.addressResult?.region_3depth_name = "" }
            }
            self.tableView.reloadData()
            self.loadingView.isHidden = true
        }
    }
}

extension SearchLocationLastViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.isEmpty ? 0 : locations.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! SearchLocationLastHeaderTableViewCell
            cell.address = addressResult
            cell.subtitleLabel.text = "(투표 장소 : \(locations.count))"
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! SearchLocationLastContentTableViewCell
        cell.location = locations[indexPath.row - 1]
        return cell
    }
}
