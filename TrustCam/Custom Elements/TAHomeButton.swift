//
//  HomeButton.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit

class TAHomeButton: UIButton {
    
    // MARK: - Properties
    
    fileprivate var titleColorNormal: UIColor = hexStringToUIColor(hex: "#000000")
    fileprivate var titleColorHighlighted: UIColor = hexStringToUIColor(hex: "#ffffff")
    fileprivate var backgroundColorNormal: UIColor = hexStringToUIColor(hex: "#D6D6D6")
    fileprivate var backgroundColorHighlighted: UIColor = hexStringToUIColor(hex: "#8FC31F")
    fileprivate var borderColorNormal: UIColor = hexStringToUIColor(hex: "#576574")
    fileprivate var shadowColorNormal: UIColor = hexStringToUIColor(hex: "#000000")
    
    // MARK: - Init Methods
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    // MARK: Highlight button animation
    
    override var isHighlighted: Bool {
        willSet(newValue) {
            if newValue {
                self.setTitleColor(titleColorHighlighted, for: .highlighted)
                self.backgroundColor = backgroundColorHighlighted
                self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
            }
            else {
                self.setTitleColor(titleColorNormal, for: .normal)
                self.backgroundColor = backgroundColorNormal
                self.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
            }
        }
    }
    
    // MARK: Button image and label autolayout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let imageViewSize = self.imageView?.frame.size, let titleLabelSize = self.titleLabel?.frame.size else {
            return
                print("error")
        }
        
        let totalHeight = imageViewSize.height + titleLabelSize.height + 15.0
        
        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width
        )
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height),
            right: 0.0
        )
        self.contentEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: 0.0,
            bottom: titleLabelSize.height,
            right: 0.0
        )
    }
    
    // MARK: - Button Methods
    
    private func setupButton() {
        setShadow()
        styleButton()
    }
    
    private func styleButton() {
        setTitleColor(titleColorNormal, for: .normal)
        backgroundColor = backgroundColorNormal
        titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.light)
        layer.borderWidth = 0.5
        layer.borderColor = borderColorNormal.cgColor
    }
    
    private func setShadow() {
        layer.shadowColor = shadowColorNormal.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.5
        clipsToBounds = true
        layer.masksToBounds = false
    }
}
