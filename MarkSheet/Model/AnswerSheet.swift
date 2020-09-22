//
//  AnswerSheet.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/04.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@objc(AnswerSheet)
public class AnswerSheet: NSManagedObject {
    @NSManaged public var mark: [Int]?
    @NSManaged public var created_at: Date?
    @NSManaged public var name: String?
    @NSManaged public var sort: Int16
    @NSManaged public var format: Format?
    
    func setDefaultName() {
        name = dateString()
    }
    
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        let now = Date(timeIntervalSinceNow: 0)
        return formatter.string(from: now)
    }
}
