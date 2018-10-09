//
//  SearchLocationMainViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 2..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class SearchLocationMainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var remianTimeText: UILabel!
    lazy var network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDiff()
    }
    
    private func getDiff() {
        var dateComponents = DateComponents()
        dateComponents.year = 2018
        dateComponents.month = 6
        dateComponents.day = 13
        dateComponents.timeZone = TimeZone(abbreviation: "KST") // Japan Standard Time
        
        // Create date from components
        let userCalendar = Calendar.current // user calendar
        let someDateTime = userCalendar.date(from: dateComponents) ?? Date()
        
        let components = userCalendar.dateComponents([.day], from: Date(), to: someDateTime)
        let day = (components.day ?? 0) + 1
        remianTimeText.text = day == 0 ? "D-day" : "D-\(day)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toResult":
            let destination = segue.destination as! SearchLocationMiddleViewController
            destination.searchText = sender as! String
        default:
            break
        }
    }
}

extension SearchLocationMainViewController: MainSearchDelegate {
    func searchCandidate(_ text: String) { }
    
    func searchAddress(_ text: String) {
        self.performSegue(withIdentifier: "toResult", sender: text)
    }
}

extension SearchLocationMainViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! MainSearchTableViewCell
        cell.inputField.placeholder = "읍·면·동 검색"
        cell.delegate = self
        return cell
    }
}
