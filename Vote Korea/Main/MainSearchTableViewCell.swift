//
//  MainSearchTableViewCell.swift
//  Vote Korea
//
//  Created by Chang Woo Son on 2018. 5. 17..
//  Copyright © 2018년 manekineko. All rights reserved.
//

import UIKit

protocol MainSearchDelegate {
    func searchCandidate(_ text: String)
    func searchAddress(_ text: String)
}

class MainSearchTableViewCell: UITableViewCell {
    @IBOutlet weak var inputField: UITextField!
    @IBOutlet weak var wrapInputView: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    
    var delegate: MainSearchDelegate?
    
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
    
    @IBAction func search(_ sender: UIButton) {
        if inputField.placeholder == "읍·면·동 검색" {
            delegate?.searchAddress(inputField.text ?? "")
        } else {
            delegate?.searchCandidate(inputField.text ?? "")
        }
    }
}

extension MainSearchTableViewCell: UITextFieldDelegate {
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        confirmButton.backgroundColor = text.isEmpty ?
            UIColor(red: 205.0/255.0, green: 205.0/255.0, blue: 205.0/255.0, alpha: 1.0) : .defaultBlack
        confirmButton.isEnabled = !text.isEmpty
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        textField.resignFirstResponder()
        if inputField.placeholder == "읍·면·동 검색" {
            delegate?.searchAddress(text)
        } else {
            delegate?.searchCandidate(text)
        }
        return true
    }
}
