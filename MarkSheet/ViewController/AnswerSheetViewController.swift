//
//  AnswerSheetViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/01.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class AnswerSheetViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QuestionCellDelegate {
    // MARK: Properties

    var scoreLabel: UILabel?
    var answerSheet: AnswerSheet? = nil {
        didSet {
            title = answerSheet?.name
        }
    }
    var format: Format?
    var numberOfQuestions: Int = 0
    var numberOfOptions: Int = 0
    var scoreMode = false
    var enterAnswerMode = false {
        didSet {
            title = ""
        }
    }

    // MARK: - IBOutlets

    @IBOutlet weak var rightButtonItem: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfQuestions = Int(format?.number_of_questions ?? 0)
        numberOfOptions = Int(format?.number_of_options ?? 0)
        rightButtonItem.title = "score".localized
        if enterAnswerMode {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = rightButtonItem
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfQuestions
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: QuestionCell = tableView.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.scoreMode = scoreMode
        cell.numberOfOption = numberOfOptions
        cell.setLeading(constant: 24 + tableView.separatorInset.left)
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

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var title: String!
        if let answer = format?.answers![indexPath.row] {
            if answer == 0 {
                title = "undefined"
            } else {
                title = String(answer)
            }
        } else {
            title = "undefined"
        }

        let contextItem = UIContextualAction(style: .normal, title: title) { (_, _, _) in
            // do nothing
        }
        contextItem.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [contextItem])
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return scoreMode ? 49 : 0
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if scoreLabel == nil {
            scoreLabel = UILabel()
            scoreLabel!.textColor = UIColor.label
            scoreLabel!.backgroundColor = UIColor.systemBackground
            scoreLabel!.textAlignment = .center

            let topBorder = CALayer()
            topBorder.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1.0)
            topBorder.backgroundColor = UIColor.lightGray.cgColor
            scoreLabel!.layer.addSublayer(topBorder)
        }
        return scoreLabel
    }

    // MARK: - QuestionCellDelegate

    func questionCellDidMark(cell: QuestionCell) {
        let indexPath = tableView!.indexPath(for: cell)
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

    // MARK: - IBActions

    @IBAction func pushRightButton(sender: Any) {
        scoreMode = !scoreMode
        if scoreMode {
            rightButtonItem.title = "answer".localized
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
            rightButtonItem.title = "score".localized
            scoreLabel?.isHidden = true
            refreshFooterView()
        }
        tableView!.reloadData()
    }

    // MARK: -

    func refreshFooterView() {
        UIView.setAnimationsEnabled(false)
        tableView!.beginUpdates()
        tableView!.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
}
