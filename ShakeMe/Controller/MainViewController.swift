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
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionBegan")
        //answerText.shake()
    }
    
    override func motionCancelled(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        print("motionCancelled")
    }
    
    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
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
        ballImageView.image = UIImage(named: Const.defaultBallImageName)
    }
}

//MARK: DataManagerDelegate

extension MainViewController: DataManagerDelegate {
    
    func didUpdateData(_ dataManager: DataManager, message: Message) {
        DispatchQueue.main.async {
            self.activityIndicatior.stopAnimating()
            self.activityIndicatior.isHidden = true
            self.answerText.isHidden = false
            self.answerText.text = message.answer
            self.okButton.isHidden = false
            var ballToShowImageName = ""
            self.ballImageView.isHidden = false
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
        print(error)
        if error.localizedDescription == Const.noDataErrorDescription {
            print("sdas")
        }
    }
}
/*
extension UIView {
    func shake(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 3
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 10, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 10, y: self.center.y))
        self.layer.add(animation, forKey: "position")
    }
}*/
