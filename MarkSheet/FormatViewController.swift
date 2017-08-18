//
//  FormatViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/07/28.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData

class FormatViewController: UITableViewController {
    
    var formats:[Format]? = nil
    var selectedFormat:Format? = nil
    var isEditMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext:NSManagedObjectContext = appDelegate.persistentContainer.viewContext
        
        let entityDiscription = NSEntityDescription.entity(forEntityName:"Format", in: managedObjectContext);
        let fetchRequest:NSFetchRequest<Format> = Format.fetchRequest() as! NSFetchRequest<Format>
        fetchRequest.entity = entityDiscription;
        let sortDescriptor = NSSortDescriptor(key:"name", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        formats = try! managedObjectContext.fetch(fetchRequest)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                        target: self,
                                        action: #selector(self.didPushAddButton(sender:)))
        navigationItem.rightBarButtonItem = barButton
    }

    @objc func didPushAddButton(sender: Any) {
        self.performSegue(withIdentifier: "DisplayMakeFormatView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formats?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let format = formats![indexPath.row]
        cell.textLabel?.text = format.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)
        
        selectedFormat = formats![indexPath.row]
        self.performSegue(withIdentifier: "DisplayAnswerSheetListView", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: .normal, title: "Delete") { (rowAction, indexPath) in
            let format:Format? = self.formats?[indexPath.row]
            let context = format?.managedObjectContext
            context?.delete(format!)
            self.formats?.remove(at: indexPath.row)
            try! context?.save()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (rowAction, indexPath) in
            self.selectedFormat = self.formats![indexPath.row]
            self.isEditMode = true
            self.performSegue(withIdentifier: "DisplayMakeFormatView", sender: self)
        }
        editAction.backgroundColor = .gray

        deleteAction.backgroundColor = .red
        
        return [deleteAction, editAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayAnswerSheetListView" {
            let destinationVC = segue.destination as! AnswerSheetListViewController
            destinationVC.format = selectedFormat
        } else if segue.identifier == "DisplayMakeFormatView" && isEditMode {
            let nc = segue.destination as! UINavigationController
            let destinationVC = nc.topViewController as! MakeFormatViewController
            destinationVC.format = selectedFormat
            
            isEditMode = false
        }
    }
}

