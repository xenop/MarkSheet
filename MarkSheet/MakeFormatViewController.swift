//
//  MakeFormatViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/09.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData

class MakeFormatViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet var nameTextField:UITextField?
    var format:Format? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                        target: self,
                                        action: #selector(self.cancel(sender:)))
        navigationItem.leftBarButtonItem = barButton
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        let managedObject: AnyObject =
            NSEntityDescription.insertNewObject(forEntityName: "Format", into: managedObjectContext)
        format = managedObject as? Format
        
        let answerSheetManagedObject: AnyObject =
            NSEntityDescription.insertNewObject(forEntityName: "AnswerSheet", into: managedObjectContext)
        let answerSheet = answerSheetManagedObject as! AnswerSheet
        answerSheet.setDefaultName()
        format?.number_of_options = 4
        format?.number_of_questions = 50
        format?.addToAnswer_sheet(answerSheet)
    }
    
    @objc func cancel(sender: Any) {
        let context = format?.managedObjectContext
        context?.delete(format!)
        try! context?.save()
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        // TODO:編集画面なら初期値設定
//        var identifier:String
//        switch (indexPath.row) {
//        case 0:
//            identifier = "nameCell"
//        case 1:
//            identifier = "numberOfOptionsCell"
//        case 2:
//            identifier = "numberOfQuestionsCell"
//        case 3:
//            identifier = "enterAnswerCell"
//        default:
//            assert(false, "unexpected row")
//            identifier = "nameCell"
//        }
//        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: "EnterAnswerSheetView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnswerSheetViewController
        
        // TODO:遷移ではなく入力終了時に設定
        format?.name = nameTextField?.text
        format?.number_of_options = 4
        format?.number_of_questions = 50
        format?.answers = Array(0..<50).map { $0 * 0 }
        let answerSheet:AnswerSheet = format?.answer_sheet?.anyObject() as! AnswerSheet
        answerSheet.mark = Array(0..<50).map { $0 * 0 }
        destinationVC.enterAnswerMode = true
        destinationVC.answerSheet = answerSheet
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        format?.name = nameTextField?.text
    }
}
