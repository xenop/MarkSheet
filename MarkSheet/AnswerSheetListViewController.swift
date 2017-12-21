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

    var format:Format? = nil {
        didSet {
            title = format?.name
        }
    }
    var answerSheetList:[AnswerSheet] {
        get {
            if let answer_sheet:NSSet = format?.answer_sheet {
                let answerSheetList = (answer_sheet.allObjects as! [AnswerSheet])
                return answerSheetList.sorted(by: {
                    $0.name! < $1.name!
                })
            } else {
                return []
            }
        }
    }
    var selectedAnswerSheet:AnswerSheet? = nil
    
    // MARK: - IBOutlets
    @IBOutlet var tableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                        target: self,
                                        action: #selector(self.pushButton(sender:)))
        navigationItem.rightBarButtonItem = barButton
    }

    @objc func pushButton(sender: Any) {
        let managedObjectContext:NSManagedObjectContext = (format?.managedObjectContext!)!
        let answerSheetManagedObject: AnyObject =
            NSEntityDescription.insertNewObject(forEntityName: "AnswerSheet", into: managedObjectContext)
        let answerSheet = answerSheetManagedObject as! AnswerSheet
        answerSheet.setDefaultName()
        let number_of_questions = Int(format?.number_of_questions ?? 0)
        answerSheet.mark = Array(0..<number_of_questions).map { $0 * 0 }
        format?.addToAnswer_sheet(answerSheet)
        
        try! managedObjectContext.save()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let now = Date(timeIntervalSinceNow: 0)
        return formatter.string(from: now)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answerSheetList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AnswerSheetCell", for: indexPath)
        let answerSheet = answerSheetList[indexPath.row]
        cell.textLabel?.text = answerSheet.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        selectedAnswerSheet = answerSheetList[indexPath.row]
        self.performSegue(withIdentifier: "DisplayAnswerSheetView", sender: self)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let answerSheet:AnswerSheet? = answerSheetList[indexPath.row]
            let context = answerSheet?.managedObjectContext
            context?.delete(answerSheet!)
            try! context?.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnswerSheetViewController
        destinationVC.format = format
        destinationVC.answerSheet = selectedAnswerSheet
    }
}
