//
//  DeviceViewController.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit
import RealmSwift

class DeviceManagerViewController: SwipeTableViewController {
    
    // MARK: - Properties
    
    var devices: Results<Device>?
    var currentIndex = IndexPath()
    
    enum Segues: String {
        case toEditDevice
        case toLiveView
        case toAddDevice
    }
    
    // MARK: - View CallBack Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.backgroundColor = hexStringToUIColor(hex: "#dcdde1")
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
        devices = Device.all()
        resetSelections()
        tableView.reloadData()
        
    }
    
    // MARK: - Navigation Methods
    
    override func actions(with descriptor: ActionDescriptor, at indexPath: IndexPath) {
        currentIndex = indexPath
        let descriptorCase = descriptor
        switch descriptorCase {
            
        case .delete:
            print("Delete on Swipe Action is disabled for now. SwipeCellKit delete section problem")
            
        case .edit:
            performSegue(withIdentifier: Segues.toEditDevice.rawValue, sender: self)
            
        case .live:
            performSegue(withIdentifier: Segues.toLiveView.rawValue, sender: self)
            
        case .select:
            selectAllChannels(for: indexPath)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let identifier = segue.identifier, let identifierCase = DeviceManagerViewController.Segues(rawValue: identifier) else {
            assertionFailure("Could not map segue identifier -- (segue.identifier) -- to segue case")
            return
        }
        
        switch identifierCase {
        case .toEditDevice:
            let deviceConfigVC = segue.destination as! DeviceConfigViewController
            if let device = devices?[currentIndex.section] {
                deviceConfigVC.selectedDevice = device
            }
            
        case .toLiveView:
            
            _ = segue.destination as! LiveViewController
            
        case .toAddDevice:
            // TODO: update segue
            _ = segue.destination as! AddDeviceViewController
        }
    }
    
    // MARK: - Unwind Segues
    
    @IBAction func saveButtonClicked(_ segue: UIStoryboardSegue) {
        
        if segue.source is AddDeviceViewController {
            resetSelections()
            tableView.reloadData()
        }
        else if segue.source is DeviceConfigViewController {
            resetSelections()
            tableView.reloadData()
        }
    }
    
    @IBAction func deleteButtonClicked(_ segue: UIStoryboardSegue) {
        if segue.source is DeviceConfigViewController {
            resetSelections()
            tableView.reloadData()
        }
    }
    
    // MARK: - Table View Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return devices?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let device = devices?[section] else { return 1 }
        let numOfRows = device.isExpanded ? device.numberOfChannel : 0
        return (numOfRows + 1)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            if let device = devices?[indexPath.section] {
                super.device = device
            }
            
            let cell = super.tableView(tableView, cellForRowAt: indexPath)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelCell") as! TAChannelCell
            
            if let channel = devices?[indexPath.section].channels[indexPath.row - 1] {
                cell.channelName.text = channel.channelName
                cell.channelImage.image = UIImage(named: "cam_thumbnail")
                
                cell.checkButton.isSelected = channel.isSelected
            }
            
            cell.delegate = self
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            guard let device = devices?[indexPath.section] else { return }
            device.toggle()
            
            let sections = IndexSet.init(integer: indexPath.section)
            tableView.reloadSections(sections, with: .none)
        }
        else {
            
        }
    }
    
    // MARK: - Select Methods
    
    func toggleChannel(for indexPath: IndexPath) {
        guard let channel = devices?[indexPath.section].channels[indexPath.row - 1] else { return }
        channel.toggle()
    }
    
    func selectAllChannels(for indexPath: IndexPath) {
        guard let device = devices?[indexPath.section] else { return }
        device.toggleAllChannels()
        device.select()
        
        tableView.reloadData()
        let cell = tableView.cellForRow(at: indexPath) as! TADeviceCell
        cell.activateSwipe(animated: false)
        
    }
    
    func resetSelections() {
        devices?.forEach {
            $0.deselect()
            $0.deselectAllChannels()
        }
    }
}

// MARK: - TAChannelCellDelegate
extension DeviceManagerViewController: TAChannelCellDelegate {
    func checkButtonTapped(cell: TAChannelCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else {return}
        toggleChannel(for: indexPath)
    }
}

