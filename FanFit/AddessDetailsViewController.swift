//
//  AddessDetailsViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 25/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class AddessDetailsViewController: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var addressLine1: UITextField!
    
    @IBOutlet weak var addressLine2: UITextField!

    @IBOutlet weak var townCity: UITextField!
    
    @IBOutlet weak var county: UITextField!
    
    @IBOutlet weak var postcode: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    
    func donePicker() {
        
        self.view.endEditing(true)
    }
    
    func toolBarSetUp() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AddessDetailsViewController.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        addressLine1.inputAccessoryView = toolBar
        addressLine2.inputAccessoryView = toolBar
        townCity.inputAccessoryView = toolBar
        county.inputAccessoryView = toolBar
        postcode.inputAccessoryView = toolBar
        
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }
    
    let validator = Validator()
    
    func setValidators() {
        
        validator.registerField(addressLine1, rules: [RequiredRule()])
        validator.registerField(townCity, rules: [RequiredRule()])
        validator.registerField(postcode, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        // submit the form
        
        let userAddress = App.Memory.currentUser.address
        
        userAddress.addressLine1 = addressLine1.text!
        userAddress.addressLine2 = addressLine2.text!
        userAddress.townCity = townCity.text!
        userAddress.county = county.text!
        userAddress.postcode = postcode.text!
        
        if App.Memory.updatingUser == false {
            performSegueWithIdentifier("toAccount", sender: self)
        } else {
            self.presentingViewController?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
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
        
        addressLine1.layer.borderColor = UIColor.clearColor().CGColor
        townCity.layer.borderColor = UIColor.clearColor().CGColor
        postcode.layer.borderColor = UIColor.clearColor().CGColor
        
        errorLabel.hidden = true
        
        validator.validate(self)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Utilities.setButtonBorder(nextButton)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        toolBarSetUp()
        
        setValidators()
        
        errorLabel.hidden = true
        
        setTextFields()
        
        if App.Memory.updatingUser == false {
            nextButton.setTitle("Next", forState: .Normal)
        } else {
            nextButton.setTitle("Update", forState: .Normal)
        }
    }
    
    func setTextFields() {
        
        let userAddress = App.Memory.currentUser.address
        
        addressLine1.text = userAddress.addressLine1
        addressLine2.text = userAddress.addressLine2
        townCity.text = userAddress.townCity
        county.text = userAddress.county
        postcode.text = userAddress.postcode
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
