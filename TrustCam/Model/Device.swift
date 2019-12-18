//
//  Device.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import Foundation
import RealmSwift

class Device: Object {
    
    // MARK: - Properties
    
    @objc dynamic var deviceID: String = UUID().uuidString
    @objc dynamic var deviceName: String = ""
    @objc dynamic var username: String = ""
    @objc dynamic var password: String = ""
    @objc dynamic var ipAddress: String = ""
    @objc dynamic var portNumber: String = ""
    @objc dynamic var nSpecCap: String = "0"
    @objc dynamic var loginHandle: Int = 0
    @objc dynamic var numberOfChannel: Int = 0
    @objc dynamic var isExpanded: Bool = false
    
    let channels = List<Channel>()
    
    // MARK: - Methods
    
    required convenience init(deviceName: String, username: String, password: String, ipAddress: String, portNumber: String) {
        self.init()
        self.deviceName = deviceName
        self.username = username
        self.password = password
        self.ipAddress = ipAddress
        self.portNumber = portNumber
    }
    
    override static func primaryKey() -> String? {
        return "deviceID"
    }
    
    open override func isEqual(_ object: Any?) -> Bool {
        if let object = object as? Device {
            return
                ipAddress == object.ipAddress &&
                    portNumber == object.portNumber
        }
        else {
            return false
        }
    }
    
    // MARK: - Data Manipulation Methods
    
    static func all(in realm: Realm = try! Realm()) -> Results<Device> {
        return realm.objects(Device.self)
    }
    
    func add(in realm: Realm = try! Realm()) {
        try! realm.write {
            realm.add(self)
        }
    }
    
    func delete() {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self.channels)
            realm.delete(self)
        }
    }
    
    func update(with device: Device) {
        guard let realm = realm else { return }
        try! realm.write {
            realm.delete(self.channels)
            self.deviceName = device.deviceName
            self.ipAddress = device.ipAddress
            self.portNumber = device.portNumber
            self.username = device.username
            self.password = device.password
            self.loginHandle = device.loginHandle
            self.numberOfChannel = device.numberOfChannel
            
            for index in 0..<device.numberOfChannel {
                let channelName = "Channel \(index + 1)"
                let channel = Channel(channelName: channelName, channelIndex: index, isActive: false)
                self.channels.append(channel)
            }
        }
    }
    
    func update(with deviceName: String) {
        guard let realm = realm else { return }
        try! realm.write {
            self.deviceName = deviceName
        }
    }
    
    // MARK: - View Manipulation Methods
    
    func toggle() {
        guard let realm = realm else { return }
        try! realm.write {
            self.isExpanded = !self.isExpanded
        }
    }
    
    func select() {
        guard let realm = realm else { return }
        try! realm.write {
            self.isExpanded = true
        }
    }
    
    func deselect() {
        guard let realm = realm else { return }
        try! realm.write {
            self.isExpanded = false
        }
    }
    
    func toggleAllChannels() {
        guard let realm = realm else { return }
        let selected = self.channels.filter {$0.isSelected == true}
        
        try! realm.write {
            if self.channels.count == selected.count {
                for channel in self.channels {
                    channel.isSelected = false
                }
            } else {
                for channel in self.channels {
                    channel.isSelected = true
                }
            }
        }
    }
    
    func deselectAllChannels() {
        guard let realm = realm else { return }
        try! realm.write {
            for channel in self.channels {
                channel.isSelected = false
            }
        }
    }
}
