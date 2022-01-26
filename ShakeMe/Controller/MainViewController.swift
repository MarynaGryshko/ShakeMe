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
        self.view.backgroundColor = Const.backgroundColor
        dataManager.delegate = self
        setDefaultScreen()
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
            setActivityIndicatorScreen()
            dataManager.fetchData()
            }
    }

//User see and accepts an answer
    @IBAction func okButtonTapped(_ sender:UIButton ) {
        setDefaultScreen()
    }

//MARK: modify screen
    func setDefaultScreen() {
        //set default screen paremeters
        setScreenWithTextAndImage(text: Const.defaultAnswerText, image: UIImage(named: Const.defaultBallImageName))
    }
    
    func setScreenWithTextAndImage(text:String?, image:UIImage?) {
        self.okButton.isHidden = true
        self.activityIndicatior.isHidden = true
        self.ballImageView.isHidden = false
        self.answerText.isHidden = false
        self.answerText.textColor = .label
        answerText.text = text
        ballImageView.image = image
    }
    
    func setActivityIndicatorScreen() {
        //set screen parameters to show an answer
        self.answerText.isHidden = true
        self.ballImageView.isHidden = true
        self.activityIndicatior.isHidden = false
        self.activityIndicatior.startAnimating()
    }
    
    func hideActivityIndicator()
    {
        self.activityIndicatior.stopAnimating()
        self.activityIndicatior.isHidden = true
        self.okButton.isHidden = false
    }

}

//MARK: DataManagerDelegate

extension MainViewController: DataManagerDelegate {
    
    func didUpdateData(_ dataManager: DataManager, message: Message) {
       
        //set screen parameters and show an answer
        DispatchQueue.main.async {
            self.hideActivityIndicator()
            var ballToShowImageName = ""
            switch message.type {
                case answerType.neutral.rawValue: ballToShowImageName = Const.neutralBallImageName
                case answerType.contrary.rawValue: ballToShowImageName = Const.contraryBallImageName
                case answerType.affirmative.rawValue: ballToShowImageName = Const.affirmativeBallImageName
                default: ballToShowImageName = Const.defaultBallImageName
            }
            self.setScreenWithTextAndImage(text: message.answer, image: UIImage(named: ballToShowImageName))
        }
    }

    func didFailWithError(error: Error) {
        //show error if it is not possible to fetch answer from the internet and from hardcoded
        if error.localizedDescription == Const.noDataErrorDescription {
            DispatchQueue.main.async {
               //set screen to show error description
                self.hideActivityIndicator()
                self.setDefaultScreen()
                self.answerText.text = Const.noDataErrorDescription
                self.answerText.textColor = .systemRed
            }
        }
    }
    

}

