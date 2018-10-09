//
//  PDFCollectionViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 31..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit
import WebKit

class PDFCollectionViewCell: UICollectionViewCell {
    var webView: WKWebView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        webView = WKWebView(frame: self.bounds)
        webView.uiDelegate = self
        self.addSubview(webView)
    }
    
    var huboid = 0
    var type = 0
    var url: String? {
        didSet {
            guard let urlString = url, let url = URL(string: urlString) else { return }
            do {
                let data = try Data(contentsOf: url)
                webView.frame = self.bounds
                webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: url.deletingLastPathComponent())
            } catch {
                if type != 0 {
                    do {
                        let urlString2 = urlString.replacingOccurrences(of: ".pdf", with: ".PDF")
                        if let url = URL(string: urlString2) {
                            let data = try Data(contentsOf: url)
                            webView.frame = self.bounds
                            webView.load(data, mimeType: "application/pdf", characterEncodingName:"", baseURL: url.deletingLastPathComponent())
                        }
                    } catch {
                        let urlString = "http://policy.nec.go.kr/svc/policy/PolicyViewDetail.do?applicant=\(huboid)"
                        guard let url = URL(string: urlString) else { return }
                        let request = URLRequest(url: url)
                        webView.frame = self.bounds
                        webView.load(request)
                    }
                }
            }
        }
    }
}

extension PDFCollectionViewCell: WKUIDelegate {
    func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
        self.webView.load(navigationAction.request)
        return nil
    }
}
