//
//  OptionTableViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/10/26.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class OptionTableViewController: UITableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
