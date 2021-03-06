//
//  AnswerSheetListViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/01.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData

class AnswerSheetListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: Properties

    var format: Format? = nil {
        didSet {
            title = format?.name
        }
    }
    var answerSheetList: [AnswerSheet] {
        get {
            if let answer_sheet: NSSet = format?.answer_sheet {
                let answerSheetList = (answer_sheet.allObjects as! [AnswerSheet])
                return answerSheetList.sorted(by: {
                    $0.name! < $1.name!
                })
            } else {
                return []
            }
        }
    }
    var selectedAnswerSheet: AnswerSheet?

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                        target: self,
                                        action: #selector(self.pushButton(sender:)))
        navigationItem.rightBarButtonItem = barButton
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AnswerSheetViewController {
            vc.format = format
            vc.answerSheet = selectedAnswerSheet
        }
    }

    // MARK: - TableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerSheetList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerSheetCell", for: indexPath)
        let answerSheet = answerSheetList[indexPath.row]
        cell.textLabel?.text = answerSheet.name
        return cell
    }

    // MARK: - TableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)

        selectedAnswerSheet = answerSheetList[indexPath.row]
        self.performSegue(withIdentifier: "DisplayAnswerSheetView", sender: self)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let answerSheet: AnswerSheet? = answerSheetList[indexPath.row]
            let context = answerSheet?.managedObjectContext
            context?.delete(answerSheet!)
            try! context?.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    // MARK: -

    @objc func pushButton(sender: Any) {
        guard let format = format,
              let managedObjectContext = format.managedObjectContext,
              let answerSheet =
                  NSEntityDescription.insertNewObject(forEntityName: "AnswerSheet", into: managedObjectContext) as? AnswerSheet else {
            return
        }
        
        answerSheet.setDefaultName()
        let number_of_questions = Int(format.number_of_questions)
        answerSheet.mark = Array(0..<number_of_questions).map { $0 * 0 }
        format.addToAnswer_sheet(answerSheet)

        try! managedObjectContext.save()
        tableView.reloadData()
    }
}
