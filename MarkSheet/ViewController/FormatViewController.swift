//
//  FormatViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/07/28.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData
import AVKit

class FormatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, IntroViewDelegate {
    // MARK: Properties

    var managedObjectContext: NSManagedObjectContext?
    var formats: [Format]?
    var selectedFormat: Format?
    var isEditMode: Bool = false
    var introView: IntroView?

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!

    // MARK: - View Controller

    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add,
                                             target: self,
                                             action: #selector(self.didPushAddButton(sender:)))
        navigationItem.rightBarButtonItem = rightBarButton
        loadData()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if UserDefaults.standard.bool(forKey: .introDidShow) == false {
            showIntro()
            UserDefaults.standard.set(true, forKey: .introDidShow)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DisplayAnswerSheetListView",
           let vc = segue.destination as? AnswerSheetListViewController {
            vc.format = selectedFormat
        } else if segue.identifier == "DisplayMakeFormatView",
                  let nc = segue.destination as? UINavigationController,
                  let vc = nc.topViewController as? MakeFormatViewController {
            if isEditMode {
                vc.editFormat = selectedFormat
                isEditMode = false
            }
            if let managedObjectContext = managedObjectContext {
                vc.managedObjectContext = managedObjectContext
            }
            vc.completionHandler = {
                self.loadData()
            }
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return formats?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let format = formats![indexPath.row]
        cell.textLabel?.text = format.name
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.setSelected(false, animated: false)

        selectedFormat = formats![indexPath.row]
        self.performSegue(withIdentifier: "DisplayAnswerSheetListView", sender: self)
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "delete".localized) { (contextualAction, view, boolValue) in
            let alert = UIAlertController(title: "", message: "confirm delete".localized,
                                          preferredStyle: UIAlertController.Style.alert)
            let delete = UIAlertAction(title: "delete".localized, style: UIAlertAction.Style.default, handler: {
                (_: UIAlertAction!) in
                let format: Format? = self.formats?[indexPath.row]
                let context = format?.managedObjectContext
                context?.delete(format!)
                self.formats?.remove(at: indexPath.row)
                try! context?.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            let cancel = UIAlertAction(title: "cancel".localized, style: UIAlertAction.Style.cancel, handler: {
                (_: UIAlertAction!) in
            })

            alert.addAction(delete)
            alert.addAction(cancel)

            self.present(alert, animated: true, completion: nil)
        }

        let editAction = UIContextualAction(style: .normal, title: "edit".localized) { (contextualAction, view, boolValue) in
            self.selectedFormat = self.formats![indexPath.row]
            self.isEditMode = true
            self.performSegue(withIdentifier: "DisplayMakeFormatView", sender: self)
        }
        editAction.backgroundColor = .gray
        deleteAction.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }

    // MARK: - IntroViewDelegate

    func close(sender: IntroView) {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        introView?.removeFromSuperview()
    }

    func play(sender: IntroView) {
        guard let path = Bundle.main.path(forResource: "tutorial", ofType: "m4v") else {
            return
        }

        let playerController = AVPlayerViewController()
        playerController.player = AVPlayer(url: URL(fileURLWithPath: path))
        self.present(playerController, animated: true, completion: {
            playerController.player!.play()
        })
    }

    // MARK: - IBActions

    @IBAction func didPushInfoButton(sender: Any) {
        #if DEBUG
            self.performSegue(withIdentifier: "DebugView", sender: self)
        #else
            showIntro()
        #endif
    }

    // MARK: -

    func showIntro() {
        if introView == nil {
            introView = UINib(nibName: "IntroView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? IntroView
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            introView!.frame = window!.bounds
            introView!.delegate = self
        }

        self.view.backgroundColor = introView!.backgroundColor
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.view.addSubview(introView!)
    }

    @objc func didPushAddButton(sender: Any) {
        self.performSegue(withIdentifier: "DisplayMakeFormatView", sender: self)
    }

    func loadData() {
        let entityDiscription = NSEntityDescription.entity(forEntityName: "Format", in: managedObjectContext!)
        let fetchRequest: NSFetchRequest<Format> = Format.fetchRequest() as! NSFetchRequest<Format>
        fetchRequest.entity = entityDiscription
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        formats = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
    }
}
