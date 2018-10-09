//
//  PDFViewController.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

class PDFViewController: UIViewController {

    var urls: [String] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    var huboid = 0
    var gubun = 0
    var type = 0
    
    lazy var network = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        if type == 0 {
            network.getPDF(huboid, gubun: gubun) { result in
                guard let result = result else { return }
                self.urls = result.map { "http://info.nec.go.kr/unielec_pdf_file/\($0.filePath.replacingOccurrences(of: ".tif", with: ".PDF"))" }
                self.collectionView.reloadData()
            }
        }
        collectionView.reloadData()
    }
}

extension PDFViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return urls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "web", for: indexPath) as! PDFCollectionViewCell
        cell.huboid = huboid
        cell.type = type
        cell.url = urls[indexPath.section]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
