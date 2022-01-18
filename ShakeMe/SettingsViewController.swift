//
//  SettingsViewController.swift
//  ShakeMe
//
//  Created by MARINA on 13.01.2022.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController
{
    var messages: [Message] = [Message(answer: "Just do it!"),Message(answer: "Never give up!"), Message(answer: "Believe in yourself!"), Message(answer: "Don't touch it!")]

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }

    @IBAction func addButtonTapped(_ sender:UIButton ) {
        let alert = UIAlertController(title: "Add answer", message: "", preferredStyle: .alert)
         alert.addTextField { (UITextField) in
         }
         alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (UIAlertAction) in
             let content = alert.textFields![0] as UITextField
             self.messages.append(Message(answer: content.text!))
             self.tableView.reloadData()
         }))
         alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
         self.present(alert, animated: true, completion: nil)
    }
}

// MARK: tableView functionality

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier, for: indexPath)
        cell.textLabel?.text = messages[indexPath.row].answer
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
    //Delete item 
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                    messages.remove(at: indexPath.row)
                }
                tableView.reloadData()
    }
}


