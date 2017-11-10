//
//  DebugViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/11/10.
//  Copyright © 2017年 xenop. All rights reserved.
//

import Foundation

class DebugViewController: UITableViewController {
    
    @IBAction func close(sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        FormatViewController.showIntro()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
