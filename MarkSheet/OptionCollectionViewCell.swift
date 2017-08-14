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
    @IBOutlet var label:UILabel?
    var markState:MarkState = MarkState.noMark {
        didSet {
            switch(markState) {
            case .noMark:
                backgroundColor = UIColor.clear
                isSelected = false
            case .marked:
                backgroundColor = UIColor.lightGray
                isSelected = true
            case .correct:
                backgroundColor = UIColor.green
                isSelected = true
            case .wrong:
                backgroundColor = UIColor.red
            }
        }
    }
    
    override func prepareForReuse() {
        isSelected = false
    }
}
