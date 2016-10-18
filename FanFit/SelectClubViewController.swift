//
//  SelectClubViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 25/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class SelectClubViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, ValidationDelegate {

    @IBOutlet weak var selectClubTextField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    
    @IBOutlet weak var nextButton: UIButton!
    
    let validator = Validator()
    
    func setValidators() {
        
        validator.registerField(selectClubTextField, errorLabel: errorLabel, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        // submit the form
        
        let alert = UIAlertController(title: "Are you sure?", message: "Please confirm that your chosen football club is \(selectClubTextField.text!)", preferredStyle: UIAlertControllerStyle.Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        alert.addAction(UIAlertAction(title: "Confirm", style: .Default, handler: { (action) -> Void in
            
            App.Memory.currentUserProfile.footballClub.club = self.selectClubTextField.text!
            
            if App.Memory.updatingUser == false {
                self.performSegueWithIdentifier("user-details", sender: self)
            } else {
                self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func validationFailed(errors:[(Validatable ,ValidationError)]) {
        // turn the fields to red
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
                validator.validate(self)
    }
    var clubOptions = [String]()
    
    func donePicker() {
        
        if selectClubTextField.text == "" {
            selectClubTextField.text = clubOptions[0]
        }
        
        self.view.endEditing(true)
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return clubOptions.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return clubOptions[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectClubTextField.text = clubOptions[row]
    }
    
    func setUpPickerView() {
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        selectClubTextField.inputView = pickerView
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SelectClubViewController.donePicker))
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        selectClubTextField.inputAccessoryView = toolBar
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Utilities.setButtonBorder(nextButton)
        
        setUpPickerView()
        
        setValidators()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
//        App.createAccount { (success) in
//            print(success)
//        }
        
        for footballClub in App.Memory.allFootballClubs {
            clubOptions.append(footballClub.club)
        }
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
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
