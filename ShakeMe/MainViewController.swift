//
//  MainViewController.swift
//  ShakeMe
//
//  Created by MARINA on 12.01.2022.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var answerText: UILabel!
    @IBOutlet weak var okButton: UIButton!
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.becomeFirstResponder()
        dataManager.delegate = self
        okButton.isHidden = true
    }

    // We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
            get {
                return true
            }
        }
    
    // Detect shake gesture
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionBegan")
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            dataManager.fetchData()
            }
    }
    
    @IBAction func okButtonTapped(_ sender:UIButton ) {
        okButton.isHidden = true
        answerText.text = Const.defaultAnswerText
    }
}

//MARK: DataManagerDelegate

extension MainViewController: DataManagerDelegate {
    
    func didUpdateData(_ dataManager: DataManager, message: Message) {
        DispatchQueue.main.async {
            self.answerText.text = message.answer
            self.okButton.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
