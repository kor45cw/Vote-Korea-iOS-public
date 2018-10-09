//
//  UpdateChecker.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 6. 1..
//  Copyright © 2018년 manekineko. All rights reserved.
//


// UpdateChecker.swift
import UIKit

// 앱버전 변동 내용
private let appId = "1383757424"
private let title = "앱 업데이트"
private let message = "새로운 버전이 출시되어 설치할 준비가 되었습니다."
private let okBtnTitle = "바로 설치하기"
private let cancelBtnTitle = "나중에"

enum UpdateType {
    case normal
    case force
}

class UpdateChecker {
    
    static func run(_ viewController: UIViewController, updateType: UpdateType, handler: @escaping (Bool) -> Void)  {
        guard let url = URL(string: "https://itunes.apple.com/kr/lookup?id=\(appId)") else { return }
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: request, completionHandler: {
            (data, _, _) in
            guard let d = data else { handler(false); return }
            do {
                guard let results = try JSONSerialization.jsonObject(with: d, options: .allowFragments) as? NSDictionary else { handler(false); return }
                guard let resultsArray = results.value(forKey: "results") as? NSArray else { handler(false); return }
                if resultsArray.count == 0 { handler(false); return }
                guard let storeVersion = (resultsArray[0] as? NSDictionary)?.value(forKey: "version") as? String else { handler(false); return }
                guard let installVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else { handler(false); return }
                guard installVersion.compare(storeVersion) == .orderedAscending else { handler(false); return }
                showAlert(viewController, updateType: updateType)
                handler(true)
            } catch {
                handler(false);
                print("Serialization error")
            }
        })
        task.resume()
    }
    
    private static func showAlert(_ viewController: UIViewController, updateType: UpdateType) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: okBtnTitle, style: .default, handler: { Void in
            guard let url = URL(string: "itms-apps://itunes.apple.com/app/id\(appId)") else { return }
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        })
        alert.addAction(okAction)
        
        if updateType == .normal {
            let cancelAction = UIAlertAction(title: cancelBtnTitle, style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        
        viewController.present(alert, animated: true, completion: nil)
    }
}
