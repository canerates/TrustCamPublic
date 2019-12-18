//
//  DeviceConfigViewController.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class DeviceConfigViewController: UIViewController {
    
    // MARK: - Properties
    
    var devices: Results<Device>?
    var selectedDevice = Device()
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var deviceNameTextField: TATextField! {
        didSet {
            if !selectedDevice.deviceName.isEmpty {
                deviceNameTextField.text = selectedDevice.deviceName
                deviceNameTextField.showFloatingLabel()
            }
        }
    }
    
    @IBOutlet weak var ipAddressTextField: TATextField! {
        didSet {
            if !selectedDevice.ipAddress.isEmpty {
                ipAddressTextField.text = selectedDevice.ipAddress
                ipAddressTextField.showFloatingLabel()
            }
        }
    }
    
    @IBOutlet weak var portTextField: TATextField! {
        didSet {
            if !selectedDevice.portNumber.isEmpty {
                portTextField.text = selectedDevice.portNumber
                portTextField.showFloatingLabel()
            }
        }
    }
    
    @IBOutlet weak var usernameTextField: TATextField! {
        didSet {
            if !selectedDevice.username.isEmpty {
                usernameTextField.text = selectedDevice.username
                usernameTextField.showFloatingLabel()
            }
        }
    }
    
    @IBOutlet weak var passwordTextField: TATextField! {
        didSet {
            if !selectedDevice.password.isEmpty {
                passwordTextField.text = selectedDevice.password
                passwordTextField.showFloatingLabel()
            }
        }
    }
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - IBActions
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        self.view.endEditing(true)
        saveButton.isEnabled = false
        editProcess()
    }
    
    @IBAction func deleteButtonClicked(_ sender: UIButton) {
        
        guard let deviceToDelete = devices?.first(where: { $0.deviceID == selectedDevice.deviceID })
            else { return }
        deleteDevice(device: deviceToDelete)
        
    }
    
    // MARK: - View CallBack Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        devices = Device.all()
        
        deviceNameTextField.delegate = self
        ipAddressTextField.delegate = self
        portTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        [deviceNameTextField,
         ipAddressTextField,
         portTextField,
         usernameTextField,
         passwordTextField].forEach {
            $0?.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        }
        
        SVProgressHUD.setBackgroundColor(hexStringToUIColor(hex: "#D6D6D6", alpha: 0.7))
        SVProgressHUD.setBorderWidth(0.5)
        SVProgressHUD.setBorderColor(hexStringToUIColor(hex: "#8FC31F"))
        SVProgressHUD.setDefaultMaskType(.gradient)
        SVProgressHUD.setDefaultStyle(.light)
    }
    
    // MARK: - Device Editing Methods
    
    func editProcess() {
        guard let deviceToEdit = devices?.first(where: { $0.deviceID == selectedDevice.deviceID })
            else { return }
        
        let newDevice = generateDevice()
        
        let _isDeviceEqual = isDeviceEqual(first: deviceToEdit, second: newDevice)
        let _isDeviceNameEqual = isDeviceNameEqual(first: deviceToEdit.deviceName, second: newDevice.deviceName)
        
        if _isDeviceEqual {
            let isDeviceExist = matchDevice(with: newDevice)
            if !isDeviceExist {
                SVProgressHUD.show(withStatus: "Device Verifying..")
                let isDeviceVerified = self.verifyDevice(for: newDevice)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    SVProgressHUD.dismiss()
                    if isDeviceVerified {
                        deviceToEdit.update(with: newDevice)
                        SVProgressHUD.showSuccess(withStatus: "Device updated")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            SVProgressHUD.dismiss()
                            self.performSegue(withIdentifier: "editSelectedDevice", sender: self)
                        }
                    }
                    else {
                        SVProgressHUD.showError(withStatus: "Device verification failure.")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            SVProgressHUD.dismiss()
                            self.saveButton.isEnabled = true
                        }
                    }
                }
            }
            else {
                SVProgressHUD.showError(withStatus: "Device is already exist")
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    SVProgressHUD.dismiss()
                    self.saveButton.isEnabled = true
                }
            }
        }
        else if _isDeviceNameEqual {
            deviceToEdit.update(with: newDevice.deviceName)
            SVProgressHUD.showSuccess(withStatus: "Device updated")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "editSelectedDevice", sender: self)
            }
        }
        else {
            SVProgressHUD.showInfo( withStatus: "Device information has no change.")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "editSelectedDevice", sender: self)
            }
        }
    }
    
    func isDeviceEqual(first currentDevice: Device, second editedDevice: Device) -> Bool {
        return currentDevice != editedDevice
    }
    
    func isDeviceNameEqual(first currentDeviceName: String, second editedDeviceName: String) -> Bool {
        return currentDeviceName != editedDeviceName
    }
    
    func generateDevice() -> Device {
        guard let deviceInfo = deviceNameTextField.text,
            let ipInfo = ipAddressTextField.text,
            let portInfo = portTextField.text,
            let userInfo = usernameTextField.text,
            let passInfo = passwordTextField.text
            else {
                fatalError("Error getting input.")
        }
        // MARK: New device instance
        let device = Device(
            deviceName: deviceInfo,
            username: userInfo,
            password: passInfo,
            ipAddress: ipInfo,
            portNumber: portInfo)
        
        return device
    }
    
    func matchDevice(with newDevice: Device) -> Bool {
        let devices = Device.all().filter {$0.deviceID != self.selectedDevice.deviceID}
        
        for device in devices {
            if device == newDevice {
                return true
            }
        }
        return false
    }
    
    func verifyDevice(for device: Device) -> Bool {
        // MARK: With SDK
        /*
         let dict = getLoginReturnValues(for: device)
         guard
         let loginHandle = dict["loginHandle"],
         let numberOfChannel = dict["byChanNum"]
         else { return false }
         
         if loginHandle != 0 {
         device.loginHandle = loginHandle
         device.numberOfChannel = numberOfChannel
         return true
         }
         else {
         print("Device verification failure.")
         return false
         }
         */
        //MARK: Without SDK
        
        let loginHandle = 10
        if loginHandle != 0 {
            device.loginHandle = loginHandle
            device.numberOfChannel = 4
            
            for index in 0..<device.numberOfChannel {
                let channelName = "Channel \(index + 1)"
                let channel = Channel(channelName: channelName, channelIndex: index, isActive: false)
                device.channels.append(channel)
            }
            return true
        }
        else { return false }
    }
    
    func deleteDevice(device: Device) {
        device.delete()
        SVProgressHUD.showSuccess(withStatus: "Device deleted")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            SVProgressHUD.dismiss()
            self.performSegue(withIdentifier: "deleteSelectedDevice", sender: self)
        }
    }
    //MARK: - Save Button Manipulation
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let deviceName = deviceNameTextField.text, !deviceName.isEmpty,
            let ipAddress = ipAddressTextField.text, !ipAddress.isEmpty,
            let port = portTextField.text, !port.isEmpty,
            let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty
            else {
                saveButton.isEnabled = false
                return
        }
        saveButton.isEnabled = true
    }
}

// MARK: - UITextFieldDelegate
extension DeviceConfigViewController: UITextFieldDelegate {
    
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
