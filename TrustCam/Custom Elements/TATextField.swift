//
//  TATextField.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit

class TATextField: UITextField {
    
    // MARK: - Properties
    
    fileprivate var textFieldBgColor: UIColor = hexStringToUIColor(hex: "#ffffff")
    fileprivate var textFieldTextColor: UIColor = hexStringToUIColor(hex: "#000000")
    fileprivate var shadowColorNormal: UIColor = hexStringToUIColor(hex: "#000000")
    fileprivate var borderColorNormal: UIColor = hexStringToUIColor(hex: "#808080")
    fileprivate var placeHolderColor: UIColor = hexStringToUIColor(hex: "#8FC31F")
    
    // Floating Label properties
    fileprivate var floatingLabel: UILabel!
    fileprivate var placeHolderText: String?
    fileprivate var floatingLabelColor: UIColor = hexStringToUIColor(hex: "#8FC31F")
    fileprivate var floatingLabelFont: UIFont = UIFont.systemFont(ofSize: 15)
    fileprivate var floatingLabelHeight: CGFloat = 30
    
    // MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupTextField()
    }
    
    // MARK: - Text Field Methods
    
    private func setupTextField() {
        self.setShadow()
        self.styleTextField()
        self.setFloatingLabel()
    }
    
    private func styleTextField() {
        layer.cornerRadius = 5.0
        layer.borderColor = borderColorNormal.cgColor
        layer.borderWidth = 1.5
        backgroundColor = textFieldBgColor
        textColor = textFieldTextColor
        tintColor = hexStringToUIColor(hex: "#000000")
        
        if let placeholderText = placeholder {
            attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [NSAttributedString.Key.foregroundColor : placeHolderColor])
        }
        clearButtonMode = UITextField.ViewMode.whileEditing
    }
    
    private func setShadow() {
        layer.shadowColor = shadowColorNormal.cgColor
        layer.shadowOffset = CGSize(width: -3.0, height: -3.0)
        layer.shadowRadius = 10
        layer.shadowOpacity = 0.1
        clipsToBounds = true
        layer.masksToBounds = false
    }
    
    // MARK: - Floating Label Methods
    
    private func setFloatingLabel() {
        
        let flotingLabelFrame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        
        floatingLabel = UILabel(frame: flotingLabelFrame)
        floatingLabel.textColor = floatingLabelColor
        floatingLabel.font = floatingLabelFont
        floatingLabel.text = self.placeholder
        
        self.addSubview(floatingLabel)
        placeHolderText = placeholder
        
        if let text = self.text, !text.isEmpty {
            showFloatingLabel()
        }
        
        // MARK: Add textfield observers
        
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: UITextField.textDidBeginEditingNotification, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: UITextField.textDidEndEditingNotification, object: self)
    }
    private func showFloatingLabelwithAnimation() {
        UIView.animate(withDuration: 0.3) {
            self.floatingLabel.frame = CGRect(x: 0, y: -self.floatingLabelHeight, width: self.frame.width, height: self.floatingLabelHeight)
        }
        self.placeholder = ""
    }

    private func hideFloatingLabelwithAnimation() {
        UIView.animate(withDuration: 0.1) {
            self.floatingLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        }
        self.placeholder = placeHolderText
    }
    
    func showFloatingLabel() {
        floatingLabel.frame = CGRect(x: 0, y: -floatingLabelHeight, width: frame.width, height: floatingLabelHeight)
        self.placeholder = ""
    }
    
    func hideFloatingLabel() {
        floatingLabel.frame = CGRect(x: 0, y: 0, width: frame.width, height: 0)
        self.placeholder = placeHolderText
    }
    
    // MARK: - Text Field Observers
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = self.text, text.isEmpty {
            showFloatingLabelwithAnimation()
        }
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = self.text, text.isEmpty {
            hideFloatingLabelwithAnimation()
        }
    }
    
    // MARK: Remove textfield observers
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
