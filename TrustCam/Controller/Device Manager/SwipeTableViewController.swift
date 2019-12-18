//
//  SwipeTableViewController.swift
//  TrustCam
//
//  Created by Caner Ates on 2019/10/28.
//  Copyright © 2019 Caner Ates All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var device = Device()
    
    enum ActionDescriptor {
        case delete, edit, live, select
        
        func title() -> String? {
            switch self {
            case .delete: return "Delete"
            case .edit: return "Edit"
            case .live: return "Live"
            case .select: return "Select All"
            }
        }
        
        func image() -> UIImage? {
            let name: String
            switch self {
            case .delete: name = "icon_delete"
            case .edit: name = "icon_edit"
            case .live: name = "icon_live"
            case .select: name = "icon_select"
            }
            return UIImage(named: name)
        }
        
        func color() -> UIColor {
            switch self {
            case .delete: return hexStringToUIColor(hex: "#ff0000")
            case .edit: return hexStringToUIColor(hex: "#636e72")
            case .live: return hexStringToUIColor(hex: "#8FC31F")
            case .select: return hexStringToUIColor(hex: "#00a8ff")
            }
        }
    }
    
    // MARK: - View CallBack Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rowHeight = 75
    }
    
    // MARK: - Methods
    
    func actions(with descriptor: ActionDescriptor, at indexPath: IndexPath) {
        // Override from subclass..
    }
    
    func configure(action: SwipeAction, with descriptor: ActionDescriptor) {
        action.title = descriptor.title()
        action.image = descriptor.image()
        action.backgroundColor = descriptor.color()
    }
}

//MARK: - SwipeTableViewCellDelegate
extension SwipeTableViewController: SwipeTableViewCellDelegate {
    
    // MARK: - Table View Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DeviceCell", for: indexPath) as! TADeviceCell
        
        cell.layer.zPosition = CGFloat(indexPath.section + 10)
        cell.device = device
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil}
        
        /*
         let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
         self.actions(with: .delete, at: indexPath)
         }
         
         configure(action: deleteAction, with: .delete)
         */
        let selectAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            self.actions(with: .select, at: indexPath)
        }
        configure(action: selectAction, with: .select)
        
        let editAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            self.actions(with: .edit, at: indexPath)
        }
        configure(action: editAction, with: .edit)
        
        let liveAction = SwipeAction(style: .default, title: nil) { (action, indexPath) in
            self.actions(with: .live, at: indexPath)
        }
        configure(action: liveAction, with: .live)
        
        return [selectAction, editAction, liveAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .none
        options.transitionStyle = .border
        return options
    }
}
