//
//  StringExtension.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/11/30.
//  Copyright © 2017年 xenop. All rights reserved.
//

import Foundation

extension String {
    var localized: String {
        if let _ = UserDefaults.standard.string(forKey: "i18n_language") {} else {
            let pre = Locale.preferredLanguages[0]
            UserDefaults.standard.set(pre, forKey: "i18n_language")
        }
        
        let lang = UserDefaults.standard.string(forKey: "i18n_language")
        
        let path = Bundle.main.path(forResource: lang, ofType: "lproj")
        let bundle = Bundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
