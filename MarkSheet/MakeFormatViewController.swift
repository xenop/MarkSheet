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
    
    var managedObjectContext:NSManagedObjectContext?
    var format:Format? = nil
    var editFormat:Format? = nil
    var completionHandler: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let managedObject: AnyObject =
            NSEntityDescription.insertNewObject(forEntityName: "Format", into: managedObjectContext!)
        format = managedObject as? Format

        if editFormat == nil {
            // 新規作成
            format?.number_of_options = 4
            format?.number_of_questions = 50
            format?.answers = Array(0..<50).map { $0 * 0 }

            let answerSheetManagedObject: AnyObject =
                NSEntityDescription.insertNewObject(forEntityName: "AnswerSheet", into: managedObjectContext!)
            let answerSheet = answerSheetManagedObject as! AnswerSheet
            answerSheet.setDefaultName()
            answerSheet.mark = Array(0..<50).map { $0 * 0 }
            format?.addToAnswer_sheet(answerSheet)
        } else {
            // 編集時
            format?.name = editFormat!.name
            format?.number_of_options = editFormat!.number_of_options
            format?.number_of_questions = editFormat!.number_of_questions
            format?.answers = editFormat!.answers
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        tableView.reloadData()
    }
    
    @IBAction func cancel(sender: Any) {
        let context = format?.managedObjectContext
        context?.delete(format!)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(sender: Any) {
        nameTextField?.resignFirstResponder()
        saveModel()
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        if indexPath.row == 0 {
            if let textField = cell.viewWithTag(10) as? UITextField {
                textField.text = format?.name
            }
        } else if indexPath.row == 1 {
            if let label = cell.viewWithTag(11) as? UILabel {
                label.text = String.init(describing:(format?.number_of_options)!)
            }
        } else if indexPath.row == 2 {
            if let label = cell.viewWithTag(12) as? UILabel {
                label.text = String.init(describing:(format?.number_of_questions)!)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 1:
            self.performSegue(withIdentifier: "ShowOption", sender: self)
        case 2:
            self.performSegue(withIdentifier: "ShowQuestion", sender: self)
        case 3:
            self.performSegue(withIdentifier: "EnterAnswerSheetView", sender: self)
        default:
            break // do nothing
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        nameTextField?.resignFirstResponder()
        if segue.identifier == "ShowOption" {
            let vc = segue.destination as! OptionTableViewController
            vc.format = format
        } else if segue.identifier == "ShowQuestion" {
            let vc = segue.destination as! QuestionTableViewController
            vc.format = format
        } else if segue.identifier == "EnterAnswerSheetView" {
            let vc = segue.destination as! AnswerSheetViewController
            vc.enterAnswerMode = true
            vc.format = format
        }
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        format?.name = nameTextField?.text
    }
    
    func saveModel() {
        let context = format?.managedObjectContext
        if editFormat != nil {
            format?.answer_sheet = editFormat!.answer_sheet
            context?.delete(editFormat!)
        }
        try! context?.save()

        completionHandler?()
    }
}
