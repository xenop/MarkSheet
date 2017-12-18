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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel!.text = NSLocalizedString("intro_page_title_1", comment: "")
        descriptionLabel!.text = NSLocalizedString("intro_page_description_1", comment: "")
    }
}
