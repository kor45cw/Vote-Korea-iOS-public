//
//  ElectionInfoViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 24..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ElectionInfoViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var firstButton: UIButton!
    @IBOutlet weak var secondButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    @IBOutlet weak var fourthButton: UIButton!
    @IBOutlet weak var fifthButton: UIButton!
    
    let typeCount = Variable(0)
    let disposeBag = DisposeBag()
    var contents: [ElectionData] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        typeCount.asObservable().map { $0 }
            .subscribe(onNext: { [weak self] in
                self?.contents = ElectionInfo.electionInfo($0)
                self?.changeButton($0)
                self?.tableView.reloadData()
            }).disposed(by: disposeBag)
    }
    
    private func changeButton(_ type: Int) {
        firstButton.isSelected = type == firstButton.tag
        firstButton.backgroundColor = type == firstButton.tag ? .defaultBlack : .buttonBackground
        
        secondButton.isSelected = type == secondButton.tag
        secondButton.backgroundColor = type == secondButton.tag ? .defaultBlack : .buttonBackground
        
        thirdButton.isSelected = type == thirdButton.tag
        thirdButton.backgroundColor = type == thirdButton.tag ? .defaultBlack : .buttonBackground
        
        fourthButton.isSelected = type == fourthButton.tag
        fourthButton.backgroundColor = type == fourthButton.tag ? .defaultBlack : .buttonBackground
        
        fifthButton.isSelected = type == fifthButton.tag
        fifthButton.backgroundColor = type == fifthButton.tag ? .defaultBlack : .buttonBackground
    }
    
    @IBAction func changeType(_ sender: UIButton) {
        typeCount.value = sender.tag
    }
}

extension ElectionInfoViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = contents[indexPath.row]
        switch data.type {
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: "title", for: indexPath) as! ElectionInfoTableViewCell
            cell.titleLabel.text = data.title
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: "content", for: indexPath) as! ElectionInfoTableViewCell
            cell.titleLabel.text = data.title
            return cell
        case .contentWithTitle:
            let cell = tableView.dequeueReusableCell(withIdentifier: "contentWithTitle", for: indexPath) as! ElectionInfoTableViewCell
            cell.titleLabel.text = data.title
            cell.subtitleLabel.text = data.subtitle
            return cell
        case .image:
            let cell = tableView.dequeueReusableCell(withIdentifier: "image", for: indexPath) as! ElectionInfoTableViewCell
            cell.targetImageView.image = data.contentImage
            return cell
        default:
            return UITableViewCell()
        }
    }
}
