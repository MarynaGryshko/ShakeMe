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
    var messages: [Message]?// = [Message(answer: "Just do it!"),Message(answer: "Never give up!"), Message(answer: "Believe in yourself!"), Message(answer: "Don't touch it!")]
    
    let dataManager = DataManager()
    var newAnswerText = ""
    var newAnswerType = ""
    
    @IBOutlet weak var tableView: UITableView!

//MARK: View lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        loadDefaultData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let array = messages {
            dataManager.saveDefaultMessages(messageArray: array)
        }
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }

    @IBAction func done(segue:UIStoryboardSegue) {
        let addDefaultAnswerVC = segue.source as! AddDefaultAnswerViewController
        newAnswerText = addDefaultAnswerVC.answerText
        newAnswerType = addDefaultAnswerVC.typeText
        let message = Message(answer: newAnswerText, type: newAnswerType)
        if self.messages != nil {
            self.messages!.append(message)
        } else {
            self.messages = [message]
        }
        self.tableView.reloadData()
    }
}

//MARK: Handling default messages
extension SettingsViewController {
      
    func loadDefaultData(){
            guard let loadedMessages = dataManager.getDefaultMessages() else {
                return
            }
            messages = loadedMessages
        }
        
    func saveDefaultData() {
            dataManager.saveDefaultMessages(messageArray: messages)
        }
}

// MARK: tableView functionality

extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if messages != nil {
            return messages!.count
        } else {return 0}
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Const.cellIdentifier, for: indexPath)
        if let answers = messages {
            cell.textLabel?.text = answers[indexPath.row].answer
            let backgroundColor = answerType(rawValue: answers[indexPath.row].type)?.color ?? .clear
            cell.backgroundColor = backgroundColor
        }
        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    
//Delete item
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if messages != nil {
                messages!.remove(at: indexPath.row)
            }
                }
                tableView.reloadData()
    }
}

