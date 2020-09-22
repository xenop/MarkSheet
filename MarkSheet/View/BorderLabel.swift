//
//  BorderLabel.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/15.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class BorderLabel: UILabel {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.borderWidth = 1
        layer.cornerRadius = frame.height / 2
    }
}
