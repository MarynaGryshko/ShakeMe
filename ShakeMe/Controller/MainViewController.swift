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
    @IBOutlet weak var activityIndicatior: UIActivityIndicatorView!
    @IBOutlet weak var ballImageView: UIImageView!
    
    var dataManager = DataManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.becomeFirstResponder()
        dataManager.delegate = self
        
        //set default screen paremeters
        okButton.isHidden = true
        activityIndicatior.isHidden = true
        activityIndicatior.style = .large
        self.view.backgroundColor = Const.backgroundColor
       
    }

//MARK: Shake handling
// We are willing to become first responder to get shake motion
    override var canBecomeFirstResponder: Bool {
            get {
                return true
            }
        }
    
// Detect shake gesture
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            
            //set screen parameters to show an answer
            answerText.isHidden = true
            ballImageView.isHidden = true
            activityIndicatior.isHidden = false
            activityIndicatior.startAnimating()
            
            dataManager.fetchData()
            }
    }

//User see and accepts an answer
    @IBAction func okButtonTapped(_ sender:UIButton ) {
        okButton.isHidden = true
        answerText.isHidden = false
        answerText.text = Const.defaultAnswerText
        self.answerText.textColor = .label
        ballImageView.image = UIImage(named: Const.defaultBallImageName)
    }
}

//MARK: DataManagerDelegate

extension MainViewController: DataManagerDelegate {
    
    func didUpdateData(_ dataManager: DataManager, message: Message) {
       
        //set screen parameters and show an answer
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            self.answerText.text = message.answer
            var ballToShowImageName = ""
            switch message.type {
                case answerType.neutral.rawValue: ballToShowImageName = Const.neutralBallImageName
                case answerType.contrary.rawValue: ballToShowImageName = Const.contraryBallImageName
                case answerType.affirmative.rawValue: ballToShowImageName = Const.affirmativeBallImageName
                default: ballToShowImageName = Const.defaultBallImageName
            }
            self.ballImageView.image = UIImage(named: ballToShowImageName)
        }
    }

    func didFailWithError(error: Error) {
        //print(error)
        //show error if it is not possible to fetch answer from the internet and from hardcoded
        if error.localizedDescription == Const.noDataErrorDescription {
            print("sdas")
            DispatchQueue.main.async {
               //set screen to show error description
                self.hideActivityIndicator()
                self.answerText.text = Const.noDataErrorDescription
                self.answerText.textColor = .systemRed
            }
        }
    }
    
    func hideActivityIndicator()
    {
        self.activityIndicatior.stopAnimating()
        self.activityIndicatior.isHidden = true
        self.answerText.isHidden = false
        self.ballImageView.isHidden = false
        self.okButton.isHidden = false
    }
}

