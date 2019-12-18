//
//  Channel.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import Foundation
import RealmSwift

class Channel: Object {
    
    // MARK: - Properties
    
    @objc dynamic var channelName: String = ""
    @objc dynamic var channelIndex: Int = 0
    @objc dynamic var isActive: Bool = false
    @objc dynamic var isSelected: Bool = false
    
    var parentDevice = LinkingObjects(fromType: Device.self, property: "channels")
    
    // MARK: - Methods
    
    required convenience init(channelName: String, channelIndex: Int, isActive: Bool) {
        self.init()
        self.channelName = channelName
        self.channelIndex = channelIndex
        self.isActive = isActive
    }
    
    // MARK: - View Manipulation Methods
    
    func toggle() {
        guard let realm = realm else { return }
        try! realm.write {
            self.isSelected = !self.isSelected
        }
    }
    
    func select() {
        guard let realm = realm else { return }
        try! realm.write {
            self.isSelected = true
        }
    }
    
    func deselect() {
        guard let realm = realm else { return }
        try! realm.write {
            self.isSelected = false
        }
    }
}

