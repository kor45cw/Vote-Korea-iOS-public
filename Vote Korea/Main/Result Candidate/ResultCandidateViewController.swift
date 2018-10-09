//
//  ResultCandidateViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift

class ResultCandidateViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var searchText = ""
    var items: [Int: Results<CandidateInfo>?] = [:]
    var index: [CandidateInfo] = []
    var firstItemIndex: [Int: Int] = [:]
    var currnetTagIndex = 0
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        search()
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
    }
    
    private func search() {
        for item in ElectionInfo.getAllItems() {
            let predicate = NSPredicate(format: "name CONTAINS %@ AND sgTypecode == \(item.value) AND status == %@", searchText, "등록")
            items[item.value] = realm.objects(CandidateInfo.self).filter(predicate)
        }
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toLast":
            let destination = segue.destination as! LastResultViewController
            if let data = sender as? CandidateInfo {
                destination.electionCode = data.sgTypecode
                destination.sggName = data.sggName
                destination.huboid = data.huboid
                destination.sdName = data.sdName
            }
        default:
            break
        }
    }
}

extension ResultCandidateViewController: SearchInputChangeDelegate {
    func change(_ text: String) {
        self.searchText = text
    }
    
    func newSearch() {
        currnetTagIndex = 0
        self.items.removeAll()
        search()
    }
    
    func change(_ index: Int) {
        currnetTagIndex = index
        self.tableView.reloadData()
    }
}

extension ResultCandidateViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: self.view.convert(location, to: tableView)) else { return nil }
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "last") as? LastResultViewController else { return nil }
        previewingContext.sourceRect = self.view.convert(tableView.rectForRow(at: indexPath), from: tableView)
        guard let cell = tableView.cellForRow(at: indexPath) as? CandidateResultTableViewCell else { return nil }
        destination.electionCode = cell.item!.sgTypecode
        destination.sggName = cell.item!.sggName
        destination.huboid = cell.item!.huboid
        destination.sdName = cell.item!.sdName
        return destination
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

extension ResultCandidateViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  items.keys.count == 0 {
            return 3
        }
        
        index = []
        firstItemIndex = [:]
        for key in items.keys.sorted() {
            if currnetTagIndex == 0 {
                firstItemIndex[index.count] = key
                for item in items[key]!! {
                    index.append(item)
                }
            } else if currnetTagIndex == key {
                firstItemIndex[index.count] = key
                for item in items[key]!! {
                    index.append(item)
                }
            }
        }
        
        return 2 + index.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! SaerchResultTableViewCell
            cell.inputText = searchText
            cell.delegate = self
            cell.count = items.map { $0.value!.count }.reduce(0, +)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagCell", for: indexPath) as! CandidateTagTableViewCell
            var temp: Dictionary<Int, Int> = [:]
            for key in items.keys.sorted() {
                if items[key]!!.count == 0 { continue }
                temp[key] = items[key]!!.count
            }
            cell.delegate = self
            cell.index = currnetTagIndex
            cell.items = temp
            cell.frame = tableView.bounds
            cell.collectionView.reloadData()
            cell.collectionViewHeightConstraint.constant = cell.collectionView.collectionViewLayout.collectionViewContentSize.height
            return cell
        case 2:
            if items.keys.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "noResultCell", for: indexPath)
                return cell
            }
            if firstItemIndex.keys.contains(indexPath.row - 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! CandidateResultTableViewCell
                cell.item = index[indexPath.row - 2]
                cell.key = firstItemIndex[indexPath.row - 2]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell2", for: indexPath) as! CandidateResultTableViewCell
                cell.item = index[indexPath.row - 2]
                return cell
            }
        default:
            if firstItemIndex.keys.contains(indexPath.row - 2) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! CandidateResultTableViewCell
                cell.item = index[indexPath.row - 2]
                cell.key = firstItemIndex[indexPath.row - 2]
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell2", for: indexPath) as! CandidateResultTableViewCell
                cell.item = index[indexPath.row - 2]
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CandidateResultTableViewCell {
            self.performSegue(withIdentifier: "toLast", sender: cell.item!)
        }
    }
}
