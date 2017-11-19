//
//  QuestionCell.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/01.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

protocol QuestionCellDelegate {
    func questionCellDidMark(cell: QuestionCell)
}

class QuestionCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet var collectionView:UICollectionView?
    var numberOfOption:Int = 0
    var mark:Int = 0
    var answer:Int = 0
    var scoreMode = false
    var delegate:QuestionCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView?.allowsMultipleSelection = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        collectionView?.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfOption
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:OptionCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionCollectionViewCell", for: indexPath) as! OptionCollectionViewCell
        cell.label?.text = "\(indexPath.row + 1)"
        if scoreMode {
            if mark == indexPath.row + 1 {
                if mark == answer {
                    cell.markState = .correct
                } else {
                    cell.markState = .marked
                }
            } else if answer == indexPath.row + 1 {
                cell.markState = .wrong
            } else {
                cell.markState = .noMark
            }
        } else {
            if mark == indexPath.row + 1 {
                cell.markState = .marked
            } else {
                cell.markState = .noMark
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if scoreMode {
            return
        }
        for (_, cell) in collectionView.visibleCells.enumerated() {
            cell.isSelected = false
            (cell as! OptionCollectionViewCell).markState = .noMark
        }
        let cell:OptionCollectionViewCell = collectionView.cellForItem(at: indexPath) as! OptionCollectionViewCell
        if mark == indexPath.row + 1 {
           mark = 0
            cell.markState = .noMark
        } else {
            mark = indexPath.row + 1
            cell.markState = .marked
        }
        delegate?.questionCellDidMark(cell: self)
    }
}
