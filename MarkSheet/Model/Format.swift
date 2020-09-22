//
//  Format.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/08/04.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit
import CoreData
import Foundation

@objc(Format)
public class Format: NSManagedObject {
    @NSManaged public var answers: [Int]?
    @NSManaged public var created_at: Date?
    @NSManaged public var name: String?
    @NSManaged public var number_of_options: Int16
    @NSManaged public var number_of_questions: Int16
    @NSManaged public var sort: Int16
    @NSManaged public var answer_sheet: NSSet?

}

extension Format {
    @objc(addAnswer_sheetObject:)
    @NSManaged public func addToAnswer_sheet(_ value: AnswerSheet)

    @objc(removeAnswer_sheetObject:)
    @NSManaged public func removeFromAnswer_sheet(_ value: AnswerSheet)

    @objc(addAnswer_sheet:)
    @NSManaged public func addToAnswer_sheet(_ values: NSSet)

    @objc(removeAnswer_sheet:)
    @NSManaged public func removeFromAnswer_sheet(_ values: NSSet)
}
