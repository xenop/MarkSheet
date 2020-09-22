//
//  QuestionTableViewController.swift
//  MarkSheet
//
//  Created by _ xenop on 2017/10/27.
//  Copyright © 2017年 xenop. All rights reserved.
//

import UIKit

class QuestionTableViewController: UITableViewController {

    var format: Format?
    var numberOfQuestions: [Int16] = [50, 100, 150, 200]

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)

        if format?.number_of_questions == numberOfQuestions[indexPath.row] {
            cell.accessoryType = .checkmark
            tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        } else {
            cell.accessoryType = .none
            tableView.deselectRow(at: indexPath, animated: false)
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark

        format?.number_of_questions = numberOfQuestions[indexPath.row]
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}
