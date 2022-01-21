//
//  AddDefaultAnswerViewController.swift
//  ShakeMe
//
//  Created by MARINA on 19.01.2022.
//

import Foundation
import UIKit

class AddDefaultAnswerViewController: UIViewController{
    
    @IBOutlet weak var answerTextField:UITextField!
    @IBOutlet weak var typeTextField:UITextField!
    
    let answerTypes: [String] = answerType.allCases.map { $0.rawValue }
    var pickerView = UIPickerView()
    
    var answerText = ""
    var typeText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        typeTextField.inputView = pickerView
        typeTextField.placeholder = "Select answer type"
        typeTextField.delegate = self

        answerTextField.placeholder = "Answer text"

    }
    
    override func viewDidAppear(_ animated: Bool) {
       super.viewDidAppear(animated)
        answerTextField.becomeFirstResponder()
    }
    
    @IBAction func cancel(segue:UIStoryboardSegue) {
    }

    @IBAction func done(segue:UIStoryboardSegue) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "doneSeque" {
            answerText = answerTextField.text!
            typeText = typeTextField.text!
        }
    }
}

//MARK: Setup PickerView
extension AddDefaultAnswerViewController: UIPickerViewDelegate, UIPickerViewDataSource
{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        answerTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return answerTypes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        typeTextField.text = answerTypes[row]
        typeTextField.resignFirstResponder()
    }
}


//MARK: Handle answer type
//Answer type must have value from enum. If another value was typed we clear textfield
extension AddDefaultAnswerViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
//Check if type value is in enum
        if !answerTypes.contains(textField.text!) {
            textField.text = ""
            
            let alertController = UIAlertController(title: "Error", message: "Answer Type is not in type list", preferredStyle: .alert)
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action:UIAlertAction!) in
                       // print("Ok button tapped");
                    }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion:nil)
        }
    }
}
