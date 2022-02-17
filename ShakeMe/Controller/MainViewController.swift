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
    
    private var dataManager = DataManager()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.becomeFirstResponder()
        self.view.backgroundColor = ConstUI.backgroundColor
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
    private func setDefaultScreen() {
        //set default screen paremeters
        setScreenWithTextAndImage(text: ConstUI.defaultAnswerText, image: UIImage(named: ConstUI.defaultBallImageName))
        self.okButton.isHidden = true
    }
    
    private func setScreenWithTextAndImage(text:String?, image:UIImage?) {
        self.activityIndicatior.isHidden = true
        self.ballImageView.isHidden = false
        self.answerText.isHidden = false
        self.answerText.textColor = .label
        answerText.text = text
        ballImageView.image = image
        //self.okButton.isHidden = false
    }
    
    private func setActivityIndicatorScreen() {
        //set screen parameters to show an answer
        self.answerText.isHidden = true
        self.ballImageView.isHidden = true
        self.activityIndicatior.isHidden = false
        self.activityIndicatior.startAnimating()
    }
    
    private func hideActivityIndicator()
    {
        self.activityIndicatior.stopAnimating()
        self.activityIndicatior.isHidden = true
        //self.okButton.isHidden = false
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
            case answerType.neutral.rawValue: ballToShowImageName = ConstUI.neutralBallImageName
            case answerType.contrary.rawValue: ballToShowImageName = ConstUI.contraryBallImageName
            case answerType.affirmative.rawValue: ballToShowImageName = ConstUI.affirmativeBallImageName
            default: ballToShowImageName = ConstUI.defaultBallImageName
            }
            self.setScreenWithTextAndImage(text: message.answer, image: UIImage(named: ballToShowImageName))
        }
    }
    
    func didFailWithError(error: Error) {
        //show error if it is not possible to fetch answer from the internet and from hardcoded
        if error.localizedDescription == ConstData.noDataErrorDescription {
            DispatchQueue.main.async {
                //set screen to show error description
                self.hideActivityIndicator()
                self.setScreenWithTextAndImage(text: ConstData.noDataErrorDescription, image: UIImage(named: ConstUI.defaultBallImageName))
                self.answerText.textColor = .systemRed
            }
        }
    }
    
    
}

