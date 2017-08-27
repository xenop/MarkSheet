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
    var isEditMode:Bool = false
    var completionHandler: (()->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel,
                                        target: self,
                                        action: #selector(self.cancel(sender:)))
        navigationItem.leftBarButtonItem = barButton
        if !isEditMode {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let managedObjectContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
            let managedObject: AnyObject =
                NSEntityDescription.insertNewObject(forEntityName: "Format", into: managedObjectContext)
            format = managedObject as? Format
            format?.number_of_options = 4
            format?.number_of_questions = 50
            format?.answers = Array(0..<50).map { $0 * 0 }

            let answerSheetManagedObject: AnyObject =
                NSEntityDescription.insertNewObject(forEntityName: "AnswerSheet", into: managedObjectContext)
            let answerSheet = answerSheetManagedObject as! AnswerSheet
            answerSheet.setDefaultName()
            answerSheet.mark = Array(0..<50).map { $0 * 0 }
            format?.addToAnswer_sheet(answerSheet)
        }
    }
    
    @objc func cancel(sender: Any) {
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
        if indexPath.row == 3 {
            self.performSegue(withIdentifier: "EnterAnswerSheetView", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! AnswerSheetViewController
        
        // TODO:遷移ではなく入力終了時に設定
        format?.name = nameTextField?.text
        destinationVC.enterAnswerMode = true
        let answerSheet:AnswerSheet = format?.answer_sheet?.anyObject() as! AnswerSheet
        destinationVC.answerSheet = answerSheet
        destinationVC.completionHandler = completionHandler
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        format?.name = nameTextField?.text
    }
}
