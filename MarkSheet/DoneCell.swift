//
//  DoneCell.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/11.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

protocol DoneCellDelegate {
    func doneCellDidPush(cell: DoneCell)
}

class DoneCell: UITableViewCell {
    
    var delegate:DoneCellDelegate? = nil
    
    @IBAction func buttonDidPush() {
        delegate?.doneCellDidPush(cell: self)
    }
}
