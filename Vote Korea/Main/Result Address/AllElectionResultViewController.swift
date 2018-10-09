//
//  AllElectionResultViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 23..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RealmSwift

class AllElectionResultViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var starLabel: UILabel!
    
    var addressResult: AddressInfo?
    let realm = try! Realm()
    var results: Results<FavoriteData>?
    var items: [Int: Any] = [:]
    var cellDatas: [(Int, String, String)] = []
    lazy var network = NetworkManager()
    var cityCode = 0
    var townCode = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        guard let address = addressResult else { return }
        let predicate = NSPredicate(format: "region_1depth_name == %@ AND region_2depth_name == %@ AND region_3depth_name == %@",address.region_1depth_name, address.region_2depth_name, address.region_3depth_name)
        results = realm.objects(FavoriteData.self).filter(predicate)
        starButton.isSelected = results?.first != nil
        starLabel.text = results?.first != nil ? "즐겨찾기 해제" : "즐겨찾기"
        starLabel.textColor = results?.first != nil ? .defaultBlack : .buttonClick
        
        var changeText = ElectionInfo.matchCity(address.region_1depth_name)
        if address.region_2depth_name != "" {
            changeText = "\(changeText) \(address.region_2depth_name)"
        }
        if address.region_3depth_name != "" {
            changeText = "\(changeText) \(address.region_3depth_name)"
        }
        let fullText = "\(changeText)의 \n선거종류와 후보자를 확인하세요."
        titleLabel.halfTextColorChange(fullText: fullText, changeText: changeText, fontSize: 19)
        
        if let item = realm.objects(CityInfo.self).filter("NAME == %@", ElectionInfo.matchCity(address.region_1depth_name)).first {
            cityCode = item.CODE
            print("cityCode", cityCode)
        }
        
        if let item = realm.objects(CityInfo.self).filter("NAME == %@", address.region_2depth_name.replacingOccurrences(of: " ", with: "")).first {
            townCode = item.CODE
            print("townCode", townCode)
        }

        
        getDatas()
    }
    
    private func getDatas() {
        guard let address = addressResult else { return }
        var predicate = NSPredicate(value: false)
        for item in ElectionInfo.getAllItems() {
            if item.value == 3 || item.value == 11 {
                predicate = NSPredicate(format: "(sggName CONTAINS %@ OR sdName CONTAINS %@) AND sgTypecode == \(item.value) AND status == %@", ElectionInfo.matchCity(address.region_1depth_name), ElectionInfo.matchCity(address.region_1depth_name), "등록")
                items[item.value] = realm.objects(CandidateInfo.self).filter(predicate).toArray(ofType: CandidateInfo.self)
            } else {
                network.getEndTown(item.value, cityCode: cityCode) { result in
                    guard let result = result else { return }
                    if item.value == 4 && !address.region_2depth_name.isEmpty {
                        let inputString = String(address.region_2depth_name.replacingOccurrences(of: ".", with: "").split(separator: " ").first!)
                        let inputString2 = address.region_2depth_name.replacingOccurrences(of: " ", with: "")
                        self.items[item.value] = result.filter({ $0.winName == inputString || $0.winName == inputString2 || $0.sggName == inputString })
                    } else if address.region_3depth_name.isEmpty {
                        var tempResult = result
                        if !address.region_2depth_name.isEmpty {
                            let inputString = String(address.region_2depth_name.replacingOccurrences(of: ".", with: "").split(separator: " ").first!)
                            let inputString2 = address.region_2depth_name.replacingOccurrences(of: " ", with: "")
                            tempResult = result.filter({ $0.winName == inputString || $0.winName == inputString2 || $0.sggName == inputString})
                        }
                        self.items[item.value] = tempResult.uniqueValues { $0.sggName }
                    } else {
                        var tempResult = result
                        if !address.region_2depth_name.isEmpty {
                            let inputString = String(address.region_2depth_name.replacingOccurrences(of: ".", with: "").split(separator: " ").first!)
                            let inputString2 = address.region_2depth_name.replacingOccurrences(of: " ", with: "")
                            tempResult = result.filter({ $0.winName == inputString || $0.winName == inputString2 || $0.sggName == inputString})
                        }
                        let inputString = String(address.region_3depth_name.replacingOccurrences(of: ".", with: "").split(separator: " ").first!)
                        for index in 0..<inputString.count {
                            tempResult = tempResult.filter({ $0.endName.contains(inputString[index]) })
                        }
                        self.items[item.value] = tempResult.uniqueValues { $0.sggName }
                    }
                    self.countLabel.text = "\(self.items.filter({ ($0.value as! NSArray).count != 0 }).count)건 (중복 선거종류 제거)"
                    self.tableView.reloadData()
                }
            }
        }
        countLabel.text = "\(items.filter({ ($0.value as! NSArray).count != 0 }).count)건 (중복 선거종류 제거)"
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "toLast":
            let destination = segue.destination as! LastResultViewController
            let data = cellDatas[sender as! Int]
            destination.electionCode = data.0
            destination.sggName = data.1
            destination.sdName = data.2
        default:
            break
        }
    }
    
    @IBAction func star(_ sender: UIButton) {
        guard let address = addressResult else { return }
        let predicate = NSPredicate(format: "region_1depth_name == %@ AND region_2depth_name == %@ AND region_3depth_name == %@",address.region_1depth_name, address.region_2depth_name, address.region_3depth_name)
        results = realm.objects(FavoriteData.self).filter(predicate)
        try! realm.write {
            if sender.isSelected {
                if let result = results {
                    realm.delete(result)
                    sender.isSelected = false
                    starLabel.text = "즐겨찾기"
                    starLabel.textColor = .buttonClick
                }
            } else {
                let newItem = realm.create(FavoriteData.self)
                newItem.setData(address)
                realm.add(newItem)
                sender.isSelected = true
                starLabel.text = "즐겨찾기 해제"
                starLabel.textColor = .defaultBlack
            }
        }
    }
}

extension AllElectionResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellDatas.removeAll()
        for item in items.keys.sorted() {
            if (items[item] as! NSArray).count == 0 { continue }
            var text = ""
            for data in (items[item] as! NSArray) {
                if let data = data as? CandidateInfo {
                    if text != data.sggName {
                        cellDatas.append((data.sgTypecode, data.sggName, data.sdName))
                    }
                    text = data.sggName
                }
                if let data = data as? EndTown {
                    if text != data.sggName {
                        cellDatas.append((item, data.sggName, data.sdName))
                    }
                    text = data.sggName
                }
            }
        }
        return cellDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = cellDatas[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! AllElectionResultTableViewCell
        cell.titleLabel.text = ElectionInfo.findName(data.0)
        cell.subtitleLabel.text = data.1
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "toLast", sender: indexPath.row)
    }
}

extension AllElectionResultViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: self.view.convert(location, to: tableView)) else { return nil }
        guard let destination = storyboard?.instantiateViewController(withIdentifier: "last") as? LastResultViewController else { return nil }
        previewingContext.sourceRect = self.view.convert(tableView.rectForRow(at: indexPath), from: tableView)
        let data = cellDatas[indexPath.row]
        destination.electionCode = data.0
        destination.sggName = data.1
        destination.sdName = data.2
        return destination
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        let array = Array(self) as! [T]
        return array
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

