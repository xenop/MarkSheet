//
//  OptionCell.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/02.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

enum MarkState {
    case noMark
    case marked
    case correct
    case wrong
}

class OptionCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label:BorderLabel?
    var markState:MarkState = MarkState.noMark {
        didSet {
            switch(markState) {
            case .noMark:
                label?.backgroundColor = UIColor.clear
                label?.textColor = UIColor.black
                label?.layer.borderWidth = 1
                isSelected = false
            case .marked:
                label?.backgroundColor = UIColor(red: 21/255.0, green: 111/255.0, blue: 223/255.0, alpha: 1)
                label?.textColor = UIColor.white
                label?.layer.borderWidth = 0
                isSelected = true
            case .correct:
                label?.backgroundColor = UIColor(red: 76/255.0, green: 216/255.0, blue: 101/255.0, alpha: 1)
                label?.textColor = UIColor.white
                label?.layer.borderWidth = 0
                isSelected = true
            case .wrong:
                label?.backgroundColor = UIColor(red: 0.92, green: 0.3, blue: 0.24, alpha: 1)
                label?.textColor = UIColor.white
                label?.layer.borderWidth = 0
            }
        }
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
}
