//
//  TAHeader.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit

protocol TAChannelCellDelegate: AnyObject {
    func checkButtonTapped(cell: TAChannelCell)
}

class TAChannelCell: UITableViewCell {
    
    // MARK: - Properties
    
    weak var delegate: TAChannelCellDelegate?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var channelImage: UIImageView!
    @IBOutlet weak var channelName: UILabel!
    @IBOutlet weak var shadowLayer: UIView!
    @IBOutlet weak var mainBackground: UIView!
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - IBActions
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        sender.isSelected = sender.isSelected ? false : true
        delegate?.checkButtonTapped(cell: self)
    }
    
    // MARK: - Init Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.shadowLayer.backgroundColor = UIColor.clear
        self.shadowLayer.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.shadowLayer.layer.shadowColor = UIColor.black.cgColor
        self.shadowLayer.layer.shadowOpacity = 0.7
        self.shadowLayer.layer.shadowRadius = 4
        
        //self.mainBackground.layer.cornerRadius = 10
        self.mainBackground.backgroundColor = UIColor.white
        self.mainBackground.layer.borderColor = UIColor.gray.cgColor
        self.mainBackground.layer.borderWidth = 0.2
        self.mainBackground.layer.masksToBounds = true
        
        //self.checkButton.imageEdgeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

