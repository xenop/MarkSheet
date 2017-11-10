//
//  IntroPage1.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/11/05.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class IntroPage: UIView {
    @IBOutlet var titleLabel:UILabel?
    @IBOutlet var descriptionLabel:UILabel?
    
    func initPage1() {
        titleLabel!.text = NSLocalizedString("intro_page_title_1", comment: "")
        descriptionLabel!.text = NSLocalizedString("intro_page_description_1", comment: "")
    }
    
    func initPage2() {
        titleLabel!.text = NSLocalizedString("intro_page_title_2", comment: "")
        descriptionLabel!.text = NSLocalizedString("intro_page_description_2", comment: "")
    }
    
    func initPage3() {
        titleLabel!.text = NSLocalizedString("intro_page_title_3", comment: "")
        descriptionLabel!.text = NSLocalizedString("intro_page_description_3", comment: "")
    }
}
