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
        if indexPath.row == 0 {
//            FormatViewController.showIntro() // TODO:instanceから呼べるようにするか削除
        } else if indexPath.row == 1 {
            var lang = UserDefaults.standard.string(forKey: "i18n_language")
            if lang == nil || lang == "ja" {
                lang = "en"
            } else {
                lang = "ja"
            }
            UserDefaults.standard.set(lang, forKey: "i18n_language")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
