//
//  AccountDetailsViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 25/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class AccountDetailsViewController: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var usernameErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    
    @IBOutlet weak var createButton: UIButton!
    
    
    func donePicker() {
        
        self.view.endEditing(true)
    }
    
    func toolBarSetUp() {
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(AccountDetailsViewController.donePicker))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        emailAddress.inputAccessoryView = toolBar
        username.inputAccessoryView = toolBar
        password.inputAccessoryView = toolBar
        passwordConfirm.inputAccessoryView = toolBar
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
        
        validator.registerField(emailAddress, errorLabel: emailErrorLabel, rules: [RequiredRule(), EmailRule(message: "Please enter a valid email")])
        validator.registerField(username, errorLabel: usernameErrorLabel, rules: [RequiredRule()])
        validator.registerField(password, errorLabel: passwordErrorLabel, rules: [RequiredRule()])
        validator.registerField(passwordConfirm, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: password)])
    }
    
    func validationSuccessful() {
        // submit the form
        
        let currentUser = App.Memory.currentUserProfile.user
        
        currentUser.username = username.text!
        currentUser.emailAddress = emailAddress.text!
        currentUser.password = password.text!
        
        App.createAccount { (success) in
            print(success)
        }
        
        let alertController = UIAlertController(title: "Sign Up", message: "You have signed up successfully", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert) in
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let swReveal = storyboard.instantiateViewControllerWithIdentifier("SWReveal")
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = swReveal
        }
        
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
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
    
    
    @IBAction func createButtonTapped(sender: UIButton) {
        emailErrorLabel.hidden = true
        usernameErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
        confirmPasswordErrorLabel.hidden = true
        
        emailAddress.layer.borderColor = UIColor.clearColor().CGColor
        username.layer.borderColor = UIColor.clearColor().CGColor
        password.layer.borderColor = UIColor.clearColor().CGColor
        passwordConfirm.layer.borderColor = UIColor.clearColor().CGColor
        
        validator.validate(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Utilities.setButtonBorder(createButton)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        toolBarSetUp()
        
        setValidators()
        
        emailErrorLabel.hidden = true
        usernameErrorLabel.hidden = true
        passwordErrorLabel.hidden = true
        confirmPasswordErrorLabel.hidden = true
        
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
