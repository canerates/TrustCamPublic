//
//  TADeviceCell.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit
import SwipeCellKit

class TADeviceCell: SwipeTableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var deviceLogo: UIImageView!
    @IBOutlet weak var deviceName: UILabel!
    @IBOutlet weak var deviceIp: UILabel!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func clickSlideButton(_ sender: UIButton) {
        activateSwipe(animated: true)
    }
    
    // MARK: - Properties
    
    var device: Device? {
        didSet {
            guard let device = device else { return }
            deviceName.text = device.deviceName
            deviceIp.text = device.ipAddress
            deviceIp.textColor = UIColor.gray
            deviceLogo.image = UIImage(named: "liveview")
        }
    }
    
    // MARK: - Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isHighlighted = false
        self.isSelected = false
        
        deviceName?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.light)
        deviceIp?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.light)
        
        self.shadowLayer.backgroundColor = UIColor.clear
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.7
        self.shadowLayer.layer.shadowRadius = 4
        
        //self.mainBackground.layer.cornerRadius = 10
        self.mainBackground.backgroundColor = hexStringToUIColor(hex: "#dcdde1")
        self.mainBackground.layer.borderColor = UIColor.gray.cgColor
        self.mainBackground.layer.borderWidth = 0.4
        self.mainBackground.layer.masksToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.isHighlighted = true
            self.isSelected = true
        } else {
            self.isHighlighted = false
            self.isSelected = true
        }
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                self.shadowLayer.layer.shadowColor = hexStringToUIColor(hex: "#8FC31F").cgColor
            } else {
                self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
            }
        }
    }
    
    override var isSelected: Bool {
        get {
            return super.isSelected
        }
        set {
            if newValue {
                self.shadowLayer.layer.shadowColor = hexStringToUIColor(hex: "#8FC31F").cgColor
            } else {
                self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
            }
        }
    }
    
    // MARK: - Custom Methods
    
    func activateSwipe(animated: Bool) {
        if (self.swipeOffset == CGFloat.zero ) {
            self.showSwipe(orientation: .right, animated: animated, completion: nil)
        }
        else {
            self.hideSwipe(animated: true)
        }
    }
}
