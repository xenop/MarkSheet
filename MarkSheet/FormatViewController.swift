//
//  FormatViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/07/28.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import AMPopTip
import AVKit

class FormatViewController: UITableViewController, EAIntroDelegate {
    
    var introView:EAIntroView? = nil
    
    var managedObjectContext:NSManagedObjectContext?
    var formats:[Format]? = nil
    var selectedFormat:Format? = nil
    var isEditMode:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.add,
                                             target: self,
                                             action: #selector(self.didPushAddButton(sender:)))
        navigationItem.rightBarButtonItem = rightBarButton
        loadData()
    }

    private func playVideo() {
        guard let path = Bundle.main.path(forResource: "tutorial", ofType:"m4v") else {
            debugPrint("video not found")
            return
        }
        let player = AVPlayer(url: URL(fileURLWithPath: path))
        let playerController = AVPlayerViewController()
        playerController.view.frame = CGRect (x:0, y:0, width:406/2, height:720/2)
        playerController.view.center = self.view.center
        self.addChildViewController(playerController)
        self.view.addSubview(playerController.view)

        playerController.player = player
        playerController.didMove(toParentViewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // introとtipViewのフラグは別々に管理する
        if UserDefaults.standard.bool(forKey: .introDidShow) == false {
            showIntro()
            UserDefaults.standard.set(true, forKey: .introDidShow)
        }
        //        showTipView()
        playVideo()

    }
    
    func showTipView() {
        let popTip = PopTip()
        popTip.bubbleColor = .orange
        popTip.offset = 3
        popTip.bubbleOffset = 1
        popTip.edgeMargin = 8

        let item = self.navigationItem.rightBarButtonItem
        let rightView = item?.value(forKey: "view") as! UIView
        
        // rightViewをそのまま渡すと、rightButton領域以外でのtapによるdismissが効かなくなるため、self.viewを渡す。
        // それに伴い、座標も変換している
        let frame:CGRect = rightView.convert(rightView.frame, to: self.view)
        popTip.show(text: "popTip_format".localized, direction: .down, maxWidth: 200, in: self.view, from: frame)
    }
    
    func showIntro() {
        let page1:EAIntroPage = EAIntroPage.init(customViewFromNibNamed: "IntroPage")
        ((page1.customView) as! IntroPage).initPage1()
        
        let window = UIApplication.shared.keyWindow
        let intro:EAIntroView = EAIntroView(frame: window!.bounds, andPages:[page1])
        intro.show(in:window, animateDuration:0.0)
    }
    
    @objc func didPushAddButton(sender: Any) {
        self.performSegue(withIdentifier: "DisplayMakeFormatView", sender: self)
    }
    
    @IBAction func didPushInfoButton(sender: Any) {
        #if DEBUG
            self.performSegue(withIdentifier: "DebugView", sender: self)
        #else
            showIntro()
        #endif
    }
    
    func loadData() {
        let entityDiscription = NSEntityDescription.entity(forEntityName:"Format", in: managedObjectContext!)
        let fetchRequest:NSFetchRequest<Format> = Format.fetchRequest() as! NSFetchRequest<Format>
        fetchRequest.entity = entityDiscription;
        let sortDescriptor = NSSortDescriptor(key:"name", ascending:true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        formats = try! managedObjectContext!.fetch(fetchRequest)
        tableView.reloadData()
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
        let deleteAction = UITableViewRowAction(style: .normal, title: "delete".localized) { (rowAction, indexPath) in
            let alert = UIAlertController(title:"", message: "confirm delete".localized,
                                          preferredStyle: UIAlertControllerStyle.alert)
            let delete = UIAlertAction(title: "delete".localized, style: UIAlertActionStyle.default, handler: {
                (action: UIAlertAction!) in
                let format:Format? = self.formats?[indexPath.row]
                let context = format?.managedObjectContext
                context?.delete(format!)
                self.formats?.remove(at: indexPath.row)
                try! context?.save()
                tableView.deleteRows(at: [indexPath], with: .fade)
            })
            let cancel = UIAlertAction(title: "cancel".localized, style: UIAlertActionStyle.cancel, handler: {
                (action: UIAlertAction!) in
            })

            alert.addAction(delete)
            alert.addAction(cancel)

            self.present(alert, animated: true, completion: nil)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "edit".localized) { (rowAction, indexPath) in
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
        } else if segue.identifier == "DisplayMakeFormatView" {
            let nc = segue.destination as! UINavigationController
            let destinationVC = nc.topViewController as! MakeFormatViewController
            if isEditMode {
                destinationVC.editFormat = selectedFormat
                isEditMode = false
            }
            destinationVC.managedObjectContext = managedObjectContext!
            destinationVC.completionHandler = {
                self.loadData()
            }
        }
    }
}

