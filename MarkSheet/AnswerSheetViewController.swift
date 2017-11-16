//
//  AnswerSheetViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/01.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class AnswerSheetViewController: UITableViewController, QuestionCellDelegate {
    var answerSheet:AnswerSheet? = nil {
        didSet {
            title = answerSheet?.name
        }
    }
    var format:Format? = nil
    var numberOfQuestions:Int = 0
    var numberOfOptions:Int = 0
    var scoreMode = false
    var barTitle = ""
    var enterAnswerMode = false

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfQuestions = Int(format?.number_of_questions ?? 0)
        numberOfOptions = Int(format?.number_of_options ?? 0)
        if !enterAnswerMode {
            // 採点ボタン
            let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                            target: self,
                                            action: #selector(self.pushButton(sender:)))
            navigationItem.rightBarButtonItem = barButton
        }
        barTitle = title!
    }

    @objc func pushButton(sender: Any) {
        scoreMode = !scoreMode
        if scoreMode {
            let answers = format?.answers!
            let mark = answerSheet?.mark!
            if answers!.count == mark!.count {
                var score = 0
                for i in 0..<answers!.count {
                    if answers![i] == mark![i] && mark![i] != 0 {
                        score += 1
                    }
                }
                title = barTitle + " \(score)/\(answers!.count)"
            } else {
                title = barTitle
            }
        } else {
            title = barTitle
        }
        tableView.reloadData()
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
}
