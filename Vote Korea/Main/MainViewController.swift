//
//  MainViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 17..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxKeyboard
import RealmSwift

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationButton: UIButton!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var remianTimeText: UILabel!
    
    let selectedItem = Variable(0)
    let disposeBag = DisposeBag()
    let realm = try! Realm()
    var favoriteLocation: Results<FavoriteData>?
    var favoriteHubo: Results<FavoriteData>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getDiff()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.registerNotification()

        if traitCollection.forceTouchCapability == .available {
            registerForPreviewing(with: self, sourceView: view)
        }
        
        selectedItem.asObservable().map { $0 }
            .subscribe(onNext: { [weak self] in
                self?.changeButtons($0)
            })
            .disposed(by: disposeBag)
        
        RxKeyboard.instance.visibleHeight
            .drive(onNext: { keyboardVisibleHeight in
                self.tableView.contentInset.bottom = keyboardVisibleHeight + 20
            })
            .disposed(by: disposeBag)
        
        let location = NSPredicate(format: "type == 0")
        favoriteLocation = realm.objects(FavoriteData.self).filter(location)
        
        let hubo = NSPredicate(format: "type == 1")
        favoriteHubo = realm.objects(FavoriteData.self).filter(hubo)
    }
    
    private func changeButtons(_ currnetSelect: Int) {
        switch currnetSelect {
        case 0:
            locationButton.shadowOpacity = 1
            nameButton.shadowOpacity = 0
            favoriteButton.shadowOpacity = 0
            locationLabel.textColor = .defaultBlack
            nameLabel.textColor = .inactive
            favoriteLabel.textColor = .inactive
        case 1:
            locationButton.shadowOpacity = 0
            nameButton.shadowOpacity = 1
            favoriteButton.shadowOpacity = 0
            locationLabel.textColor = .inactive
            nameLabel.textColor = .defaultBlack
            favoriteLabel.textColor = .inactive
        case 2:
            locationButton.shadowOpacity = 0
            nameButton.shadowOpacity = 0
            favoriteButton.shadowOpacity = 1
            locationLabel.textColor = .inactive
            nameLabel.textColor = .inactive
            favoriteLabel.textColor = .defaultBlack
        default:
            break
        }
        tableView.reloadData()
    }
    
    @IBAction func headerButtonClick(_ sender: UIButton) {
        selectedItem.value = sender.tag
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
        case "toAddress":
            let destination = segue.destination as! ResultAddressViewController
            destination.searchText = sender as! String
        case "toCandidate":
            let destination = segue.destination as! ResultCandidateViewController
            destination.searchText = sender as! String
        case "toLocation":
            let destination = segue.destination as! AllElectionResultViewController
            if let sender = sender as? AddressInfo {
                destination.addressResult = sender
            }
        case "toHubo":
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

extension MainViewController: MainSearchDelegate {
    func searchAddress(_ text: String) {
        self.performSegue(withIdentifier: "toAddress", sender: text)
    }
    
    func searchCandidate(_ text: String) {
        self.performSegue(withIdentifier: "toCandidate", sender: text)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch selectedItem.value {
        case 0, 1:
            return 2
        case 2:
            var count = 3
            if let favoriteLocation = favoriteLocation {
                count = count + (favoriteLocation.isEmpty ? 1 : favoriteLocation.count)
            } else {
                count = count + 1
            }
            
            if let favoriteHubo = favoriteHubo {
                count = count + (favoriteHubo.isEmpty ? 1 : favoriteHubo.count)
            } else {
                count = count + 1
            }
            return count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if selectedItem.value != 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! MainSearchTableViewCell
                cell.inputField.placeholder = selectedItem.value == 0 ? "읍·면·동 검색" : "후보자 이름으로 검색"
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteHeader", for: indexPath) as! FavoriteHeaderTableViewCell
                cell.titleLabel.text = "저장한 선거구 : \(favoriteLocation?.count ?? 0)"
                return cell
            }
        case 1:
            if selectedItem.value == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath)
                return cell
            } else if selectedItem.value == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "warningCell", for: indexPath)
                return cell
            } else if (favoriteLocation?.count ?? 0) == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteNo", for: indexPath) as! FavoriteHeaderTableViewCell
                cell.titleLabel.text = "즐겨찾기에 저장한 선거구가 없습니다."
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! AddressResultTableViewCell
                cell.favoriteItem = favoriteLocation?[0]
                return cell
            }
        default:
            guard let favoriteLocation = favoriteLocation, let favoriteHubo = favoriteHubo else {
                return UITableViewCell()
            }
            
            if (favoriteLocation.count == 0 || favoriteLocation.count == 1) {
                if indexPath.row == 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteHeader", for: indexPath) as! FavoriteHeaderTableViewCell
                    cell.titleLabel.text = "저장한 후보자 : \(favoriteHubo.count)"
                    return cell
                } else if favoriteHubo.count == 0 {
                    if indexPath.row == 3 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteNo", for: indexPath) as! FavoriteHeaderTableViewCell
                        cell.titleLabel.text = "즐겨찾기에 저장한 후보자가 없습니다."
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: "warningCell", for: indexPath)
                        return cell
                    }
                } else if favoriteHubo.count >= indexPath.row - 2 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell2", for: indexPath) as! CandidateResultTableViewCell
                    cell.huboid = favoriteHubo[indexPath.row - 3].huboid
                    return cell
                }
            } else {
                if favoriteLocation.count > indexPath.row - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell", for: indexPath) as! AddressResultTableViewCell
                    cell.favoriteItem = favoriteLocation[indexPath.row - 1]
                    return cell
                } else if favoriteLocation.count == indexPath.row - 1 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "favoriteHeader", for: indexPath) as! FavoriteHeaderTableViewCell
                    cell.titleLabel.text = "저장한 후보자 : \(favoriteHubo.count)"
                    return cell
                } else if favoriteHubo.count > indexPath.row - 2 - favoriteLocation.count {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "resultCell2", for: indexPath) as! CandidateResultTableViewCell
                    cell.huboid = favoriteHubo[indexPath.row - 2 - favoriteLocation.count].huboid
                    return cell
                }
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "warningCell", for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? CandidateResultTableViewCell {
            self.performSegue(withIdentifier: "toHubo", sender: cell.item)
        }
        if let cell = tableView.cellForRow(at: indexPath) as? AddressResultTableViewCell {
            self.performSegue(withIdentifier: "toLocation", sender: cell.item)
        }
    }
}

extension MainViewController: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        guard let indexPath = tableView.indexPathForRow(at: self.view.convert(location, to: tableView)) else { return nil }
        
        previewingContext.sourceRect = self.view.convert(tableView.rectForRow(at: indexPath), from: tableView)
        if let cell = tableView.cellForRow(at: indexPath) as? CandidateResultTableViewCell {
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "last") as? LastResultViewController else { return nil }
            destination.electionCode = cell.item!.sgTypecode
            destination.sggName = cell.item!.sggName
            destination.huboid = cell.item!.huboid
            destination.sdName = cell.item!.sdName
            return destination
        } else if let cell = tableView.cellForRow(at: indexPath) as? AddressResultTableViewCell {
            guard let destination = storyboard?.instantiateViewController(withIdentifier: "allresult") as? AllElectionResultViewController else { return nil }
            destination.addressResult = cell.item
            return destination
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
