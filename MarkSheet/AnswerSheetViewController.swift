//
//  AnswerSheetViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/01.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

protocol AnswerSheetViewControllerDelegate {
    func didSetAnswer() ->Void
}

class AnswerSheetViewController: UITableViewController, QuestionCellDelegate, DoneCellDelegate {
    var answerSheet:AnswerSheet? = nil {
        didSet {
            title = answerSheet?.name
        }
    }
    
    var numberOfQuestions:Int = 0
    var numberOfOptions:Int = 0
    var scoreMode = false
    var barTitle = ""
    var enterAnswerMode = false
    var delegate:AnswerSheetViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfQuestions = Int(answerSheet?.format?.number_of_questions ?? 0)
        numberOfOptions = Int(answerSheet?.format?.number_of_options ?? 0)
        if !enterAnswerMode {
            let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done,
                                            target: self,
                                            action: #selector(self.pushButton(sender:)))
            navigationItem.rightBarButtonItem = barButton
        }
        barTitle = title!
        navigationController?.navigationBar.topItem?.title = ""
    }

    @objc func pushButton(sender: Any) {
        scoreMode = !scoreMode
        if scoreMode {
            let answers = answerSheet?.format?.answers!
            let mark = answerSheet?.mark!
            if answers!.count == mark!.count {
                var score = 0
                for i in 0..<answers!.count {
                    if answers![i] == mark![i] {
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
        if enterAnswerMode {
            return numberOfQuestions + 1
        } else {
            return numberOfQuestions
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if enterAnswerMode && indexPath.row == numberOfQuestions {
            let cell:DoneCell = tableView.dequeueReusableCell(withIdentifier: "doneCell", for: indexPath) as! DoneCell
            cell.delegate = self
            return cell
        }
        let cell:QuestionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.scoreMode = scoreMode
        cell.numberOfOption = numberOfOptions
        cell.textLabel?.text = "\(indexPath.row + 1)"
        if enterAnswerMode {
            cell.mark = (answerSheet?.format?.answers![indexPath.row])!
        } else {
            cell.answer = (answerSheet?.format?.answers![indexPath.row])!
            cell.mark = (answerSheet?.mark![indexPath.row])!
        }
        cell.delegate = self
        return cell
    }
    
    func questionCellDidMark(cell: QuestionCell) {
        let indexPath = tableView.indexPath(for: cell)
        if let row = indexPath?.row {
            if enterAnswerMode {
                answerSheet?.format?.answers![row] = cell.mark
            } else {
                answerSheet?.mark![row] = cell.mark
                let context = answerSheet?.managedObjectContext
                try! context?.save()
            }
        }
    }
    
    func doneCellDidPush(cell: DoneCell) {
        // TODO:空チェック
        var answerFilled = true
        answerSheet?.format?.answers!.forEach({ (answer) in
            if answer == 0 {
                answerFilled = false
            }
        })
//        if !answerFilled {
//            print("yet")
//            // 全部選択されていないけど良いですかと確認
//            let alert = UIAlertController(title:"タイトル", message: "メッセージ", preferredStyle: UIAlertControllerStyle.alert)
//            let action1 = UIAlertAction(title: "アクション１", style: UIAlertActionStyle.default, handler: {
//                (action: UIAlertAction!) in
//                print("アクション１をタップした時の処理")
//            })
//            let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
//                (action: UIAlertAction!) in
//                print("キャンセルをタップした時の処理")
//            })
//
//            alert.addAction(action1)
//            alert.addAction(cancel)
//
//            present(alert, animated: true, completion: nil)
//        } else {
            self.delegate?.didSetAnswer()
            dismiss(animated: true, completion: nil)
//        }
    }
}
