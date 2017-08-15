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
                isSelected = false
            case .marked:
                label?.backgroundColor = UIColor.lightGray
                isSelected = true
            case .correct:
                label?.backgroundColor = UIColor.green
                isSelected = true
            case .wrong:
                label?.backgroundColor = UIColor.red
            }
        }
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
}
