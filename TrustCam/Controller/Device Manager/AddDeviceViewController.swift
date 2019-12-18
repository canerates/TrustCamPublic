//
//  AddDeviceViewController.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class AddDeviceViewController: UIViewController {
    
    // MARK: - Properties
    
    var newDevice: Device?
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var deviceNameTextField: TATextField!
    @IBOutlet weak var ipAddressTextField: TATextField!
    @IBOutlet weak var portTextField: TATextField!
    @IBOutlet weak var usernameTextField: TATextField!
    @IBOutlet weak var passwordTextField: TATextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    // MARK: - IBActions
    
    @IBAction func saveButtonClicked(_ sender: UIBarButtonItem) {
        
        self.view.endEditing(true)
        saveButton.isEnabled = false
        saveProcess()
    }
    
    // MARK: - View CallBack Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        deviceNameTextField.delegate = self
        ipAddressTextField.delegate = self
        portTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        saveButton.isEnabled = false
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
    
    // MARK: - Device Saving Methods
    
    func saveProcess() {
        let device = self.generateDevice()
        let isDeviceExist = self.matchDevice(with: device)
        if !isDeviceExist {
            SVProgressHUD.show(withStatus: "Device verifiying..")
            let isDeviceVerified = self.verifyDevice(for: device)
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                SVProgressHUD.dismiss()
                if isDeviceVerified {
                    device.add()
                    SVProgressHUD.showSuccess(withStatus: "Device saved")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        SVProgressHUD.dismiss()
                        self.performSegue(withIdentifier: "addNewDevice", sender: self)
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
        let devices = Device.all()
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
                let channel = Channel(channelName: channelName, channelIndex: index , isActive: false)
                device.channels.append(channel)
            }
            return true
        }
        else { return false }
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
extension AddDeviceViewController: UITextFieldDelegate {
    
    // MARK: - TextField Delegate Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
