//
//  LastResultViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import StoreKit
import RealmSwift

protocol PDFDelegate {
    func click(_ sender: (Int, Int))
}

class LastResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    var datas: Results<CandidateInfo>?
    let realm = try! Realm()
    var electionCode: Int?
    var sggName: String?
    var currentIndex = 0
    var huboid = 0
    var sdName = ""
    var sggJungsu = 0
    
    lazy var network = NetworkManager()
    var detailDatas: [CandidateDetailInfo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if sggName == sdName {
            let predicate = NSPredicate(format: "sggName CONTAINS %@ AND sgTypecode == \(electionCode!) AND status == %@", sggName!, "등록")
            datas = realm.objects(CandidateInfo.self).filter(predicate)
        } else {
            let predicate = NSPredicate(format: "sdName CONTAINS %@ AND sggName CONTAINS %@ AND sgTypecode == \(electionCode!) AND status == %@", sdName, sggName!, "등록")
            datas = realm.objects(CandidateInfo.self).filter(predicate)
        }
        network.getsggJungsu(electionCode!, filter: sggName!) { result in
            guard let item = result else { return }
            self.sggJungsu = item
            self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        }
        
        guard let datas = datas else { return }
        if let index = datas.index(where: { $0.huboid == huboid }) {
            currentIndex = index
        }
        for data in datas {
            detailDatas.removeAll()
            network.getCandidateDetail(data.huboid) { result in
                guard let result = result else { return }
                self.detailDatas.append(result)
                self.tableView.reloadData()
                self.loadingView.isHidden = true
            }
        }
        
        if #available(iOS 10.3, *) {
            if isAllowedToOpenStoreReview() {
                SKStoreReviewController.requestReview()
            }
        }
    }
    
    func isAllowedToOpenStoreReview() -> Bool {
        // get user default value if set or 0 if it's not set
        let launchCount = UserDefaults.standard.integer(forKey: "launchCount")
        if launchCount == 0 || launchCount == 2 || launchCount == 9 {
            UserDefaults.standard.set((launchCount + 1), forKey: "launchCount")
            return true
        } else {
            // Increase launch count
            UserDefaults.standard.set((launchCount + 1), forKey: "launchCount")
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toPDF":
            let destination = segue.destination as! PDFViewController
            if let data = sender as? (Int, Int) {
                destination.gubun = data.1
                destination.huboid = data.0
                if data.1 == -1 {
                    if let item = realm.objects(CityInfo.self).filter("NAME == %@", sggName!).first {
                        destination.type = 1
                        destination.urls = ["http://static.news.naver.net/image/pdf/election/region2018/candidate/pledge/\(electionCode!)20180613_\(item.CODE)_\(data.0).pdf"]
                    } else {
                        destination.type = -1
                        destination.urls = ["empty"]
                    }
                }
            }
        default:
            break
        }
    }
}

extension LastResultViewController: PDFDelegate {
    func click(_ sender: (Int, Int)) {
        self.performSegue(withIdentifier: "toPDF", sender: sender)
    }
}

extension LastResultViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if detailDatas.isEmpty {
            return 1
        }
        return (electionCode! == 11 || electionCode! == 10) ? 15 : 16
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "header", for: indexPath) as! LastResultHeaderTableViewCell
            cell.electionTypeLabel.text = ElectionInfo.findName(electionCode!)
            cell.electionCode = electionCode!
            cell.sggJungsu = sggJungsu
            cell.datas = datas
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "main", for: indexPath) as! LastResultMainTableViewCell
            cell.currentIndex = currentIndex
            cell.delegate = self
            cell.datas = datas
            cell.detailDatas = detailDatas
            cell.leftButton.addTarget(self, action: #selector(changeHubo(_:)), for: .touchUpInside)
            cell.rightButton.addTarget(self, action: #selector(changeHubo(_:)), for: .touchUpInside)
            return cell
        } else if ((indexPath.row == 6 && (electionCode! == 10 || electionCode! == 11)) ||
                    (indexPath.row == 7 && (electionCode! != 10 && electionCode! != 11))) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "info2", for: indexPath) as! LastResultInfoTableViewCell
            cell.currentIndex = currentIndex
            cell.electionCode = electionCode!
            cell.row = indexPath.row - 1
            cell.datas = datas
            cell.detailDatas = detailDatas
            return cell
        } else if ((indexPath.row == 8 || indexPath.row == 14 || indexPath.row == 15 || indexPath.row == 9 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 13) && (electionCode! != 10 && electionCode! != 11)) || ((indexPath.row == 7 || indexPath.row == 13 || indexPath.row == 8 || indexPath.row == 10 || indexPath.row == 11 || indexPath.row == 12 || indexPath.row == 14) && (electionCode! == 10 || electionCode! == 11)) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "info3", for: indexPath) as! LastResultInfoTableViewCell
            cell.currentIndex = currentIndex
            cell.electionCode = electionCode!
            cell.row = indexPath.row - 1
            cell.datas = datas
            cell.delegate = self
            cell.detailDatas = detailDatas
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "info", for: indexPath) as! LastResultInfoTableViewCell
        cell.currentIndex = currentIndex
        cell.electionCode = electionCode!
        cell.row = indexPath.row - 1
        cell.datas = datas
        cell.detailDatas = detailDatas
        return cell
    }
    
    @objc func changeHubo(_ sender: UIButton) {
        
        if sender.tag == 0 {
            currentIndex = currentIndex - 1
            if currentIndex < 0 {
                currentIndex = 0
                return
            }
        } else {
            currentIndex = currentIndex + 1
            if currentIndex >= detailDatas.count {
                currentIndex = detailDatas.count - 1
                return
            }
        }
        self.tableView.reloadData()
    }
}
