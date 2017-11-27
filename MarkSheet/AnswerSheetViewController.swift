//
//  AnswerSheetViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/01.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class AnswerSheetViewController: UITableViewController, QuestionCellDelegate {
    @IBOutlet var rightButtonItem:UIBarButtonItem? = nil
    var scoreLabel:UILabel? = nil
    var answerSheet:AnswerSheet? = nil {
        didSet {
            title = answerSheet?.name
        }
    }
    var format:Format? = nil
    var numberOfQuestions:Int = 0
    var numberOfOptions:Int = 0
    var scoreMode = false
    var enterAnswerMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfQuestions = Int(format?.number_of_questions ?? 0)
        numberOfOptions = Int(format?.number_of_options ?? 0)
        rightButtonItem?.title = NSLocalizedString("score", comment: "")
        if enterAnswerMode {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = rightButtonItem
        }
    }
    
    @IBAction func pushRightButton(sender: Any) {
        scoreMode = !scoreMode
        if scoreMode {
            rightButtonItem?.title = NSLocalizedString("answer", comment: "")
            let answers = format?.answers!
            let mark = answerSheet?.mark!
            if answers!.count == mark!.count {
                var score = 0
                for i in 0..<answers!.count {
                    if answers![i] == mark![i] && mark![i] != 0 {
                        score += 1
                    }
                }
                scoreLabel?.isHidden = false
                refreshFooterView()
                scoreLabel!.text = " \(score)/\(answers!.count)"
            }
        } else {
            rightButtonItem?.title = NSLocalizedString("score", comment: "")
            scoreLabel?.isHidden = true
            refreshFooterView()
        }
        tableView.reloadData()
    }
    
    func refreshFooterView() {
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfQuestions
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QuestionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.scoreMode = scoreMode
        cell.numberOfOption = numberOfOptions
        cell.textLabel?.text = "\(indexPath.row + 1)"
        cell.textLabel?.font = UIFont.systemFont(ofSize: 12)
        
        if enterAnswerMode {
            cell.mark = (format?.answers![indexPath.row])!
        } else {
            cell.answer = (format?.answers![indexPath.row])!
            cell.mark = (answerSheet?.mark![indexPath.row])!
        }
        cell.delegate = self
        return cell
    }
    
    func questionCellDidMark(cell: QuestionCell) {
        let indexPath = tableView.indexPath(for: cell)
        if let row = indexPath?.row {
            if enterAnswerMode {
                format?.answers![row] = cell.mark
            } else {
                answerSheet?.mark![row] = cell.mark
                let context = answerSheet?.managedObjectContext
                try! context?.save()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        // just show answer
        var title:String!
        if let answer = format?.answers![indexPath.row] {
            if answer == 0 {
                title = "undefined"
            } else {
                title = String(answer)
            }
        } else {
            title = "undefined"
        }
        
        let noAction = UITableViewRowAction(style: .normal, title: title) { (rowAction, indexPath) in
            // do nothing
        }
        
        noAction.backgroundColor = .red
        
        return [noAction]
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return scoreMode ? 49 : 0
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if scoreLabel == nil {
            scoreLabel = UILabel()
            scoreLabel!.backgroundColor = UIColor(white: 0.976, alpha: 1)
            scoreLabel!.textAlignment = .center
            
            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1.0)
            topBorder.backgroundColor = UIColor.lightGray.cgColor
            scoreLabel!.layer.addSublayer(topBorder)
        }
        return scoreLabel
    }
}
