//
//  PersonalDetailsViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 25/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class PersonalDetailsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, ValidationDelegate {
    
    var finalDate = NSDate()
    
    @IBOutlet weak var usersTitle: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    @IBOutlet weak var gender: UITextField!
    
    let genderSelection = ["Male", "Female"]
    
    @IBOutlet weak var birthDate: UITextField!
    
    @IBOutlet weak var weight: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderSelection.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderSelection[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        return gender.text = genderSelection[row]
    }
    
    func datePickerChanged(sender: UIDatePicker) {
        
        finalDate = sender.date
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .LongStyle
        birthDate.text = formatter.stringFromDate(sender.date)
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        
        var maxLength = 25
        if usersTitle.isFirstResponder() {
            maxLength = 4
        }
        if weight.isFirstResponder() {
            maxLength = 3
        }
        let currentString: NSString = textField.text!
        let newString: NSString =
            currentString.stringByReplacingCharactersInRange(range, withString: string)
        return newString.length <= maxLength
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if birthDate.isFirstResponder() {
            
            let datePicker = UIDatePicker()
            
            datePicker.datePickerMode = .Date
            
            datePicker.date = finalDate
            
            birthDate.inputView = datePicker
            
            datePicker.addTarget(self, action: #selector(PersonalDetailsViewController.datePickerChanged(_:)), forControlEvents: .ValueChanged)
            
            datePickerChanged(datePicker)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }
    
    func donePicker() {
        
        if gender.isFirstResponder() && gender.text == "" {
            gender.text = genderSelection[0]
        }
        
        self.view.endEditing(true)
    }
    
    func toolBarSetUp() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PersonalDetailsViewController.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        usersTitle.inputAccessoryView = toolBar
        firstName.inputAccessoryView = toolBar
        lastName.inputAccessoryView = toolBar
        gender.inputAccessoryView = toolBar
        weight.inputAccessoryView = toolBar
        birthDate.inputAccessoryView = toolBar
        
    }
    
    let validator = Validator()
    
    func setValidators() {
        
        validator.registerField(usersTitle, rules: [RequiredRule()])
        validator.registerField(firstName, rules: [RequiredRule()])
        validator.registerField(lastName, rules: [RequiredRule()])
        validator.registerField(gender, rules: [RequiredRule()])
        validator.registerField(weight, rules: [RequiredRule()])
        validator.registerField(birthDate, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        // submit the form
        
        let currentUser = App.Memory.currentUser
        
        currentUser.title = usersTitle.text!
        currentUser.firstName = firstName.text!
        currentUser.lastName = lastName.text!
        currentUser.gender = gender.text!
        currentUser.weight = Int(weight.text!)!
        currentUser.birthDate = finalDate
        
        performSegueWithIdentifier("toAddress", sender: self)
    }
    
    func validationFailed(errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
        errorLabel.hidden = false
        for (field, error) in errors {
            if let field = field as? UITextField {
                field.layer.borderColor = UIColor.redColor().CGColor
                field.layer.borderWidth = 1.0
            }
            error.errorLabel?.text = error.errorMessage // works if you added labels
            error.errorLabel?.hidden = false
        }
    }
    
    
    @IBAction func nextButtonTapped(sender: UIButton) {
        usersTitle.layer.borderColor = UIColor.clearColor().CGColor
        firstName.layer.borderColor = UIColor.clearColor().CGColor
        lastName.layer.borderColor = UIColor.clearColor().CGColor
        gender.layer.borderColor = UIColor.clearColor().CGColor
        weight.layer.borderColor = UIColor.clearColor().CGColor
        birthDate.layer.borderColor = UIColor.clearColor().CGColor
        
        errorLabel.hidden = true
        validator.validate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        setTextFields()
        
        Utilities.setButtonBorder(nextButton)
        
        let genderPicker = UIPickerView()
        
        genderPicker.delegate = self
        
        gender.inputView = genderPicker
        
        birthDate.delegate = self
        
        usersTitle.delegate = self
        
        firstName.delegate = self
        
        lastName.delegate = self
        
        gender.delegate = self
        
        weight.delegate = self
        
        toolBarSetUp()
        
        setValidators()
        
        errorLabel.hidden = true
        
    }
    
    func setTextFields() {
        
        let currentUser = App.Memory.currentUser
        
        usersTitle.text = currentUser.title
        firstName.text = currentUser.firstName
        lastName.text = currentUser.lastName
        gender.text = currentUser.gender
        
        if App.Memory.updatingUser {
            weight.text = String(currentUser.weight)
            
            let formatter = NSDateFormatter()
            formatter.dateStyle = .LongStyle
            birthDate.text = formatter.stringFromDate(currentUser.birthDate)
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
