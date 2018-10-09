//
//  SaerchResultTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 21..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

protocol SearchInputChangeDelegate {
    func change(_ text: String)
    func newSearch()
    func change(_ index: Int)
}

class SaerchResultTableViewCell: UITableViewCell {

    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var countItems: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var wrapInputView: UIView!
    
    var delegate: SearchInputChangeDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        inputField.delegate = self
        inputField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        wrapInputView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(getFirstResponder))
        wrapInputView.addGestureRecognizer(gesture)
    }
    
    @objc func getFirstResponder() {
        inputField.becomeFirstResponder()
    }
    
    var inputText: String? {
        didSet {
            guard let text = inputText else { return }
            inputField.text = text
            confirmButton.backgroundColor = text.isEmpty ?
                UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1.0) : .defaultBlack
            confirmButton.isEnabled = !text.isEmpty
        }
    }
    
    var type = 0
    var count: Int? {
        didSet {
            guard let count = count else { return }
            countItems.text = "\(count)건"
            if type == 0 {
                resultLabel.text = count == 0 ? "검색된 결과가 없습니다." : "해당 검색결과를 선택하세요."
            } else {
                resultLabel.text = count == 0 ? "검색된 결과가 없습니다." : "해당 투표소 지역을 선택하세요."
            }
        }
    }
    
    @IBAction func search(_ sender: UIButton) {
        inputField.resignFirstResponder()
        delegate?.newSearch()
    }
}

extension SaerchResultTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        delegate?.change(text)
        confirmButton.backgroundColor = text.isEmpty ?
            UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1.0) : .defaultBlack
        confirmButton.isEnabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        textField.resignFirstResponder()
        delegate?.newSearch()
        return true
    }
}
