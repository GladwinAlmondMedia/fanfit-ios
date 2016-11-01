//
//  PasswordResetViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 04/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class PasswordResetViewController: UIViewController, ValidationDelegate, UITextFieldDelegate {

//    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!

    @IBOutlet weak var confirmPasswordErrorLabel: UILabel!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var passwordConfirm: UITextField!
    
    @IBOutlet weak var resetPasswordButton: UIButton!
    
    @IBAction func resetButtonTapped(sender: AnyObject) {
        passwordErrorLabel.hidden = true
        confirmPasswordErrorLabel.hidden = true
        
        validator.validate(self)
    }
    let validator = Validator()
    
    func setValidators() {

        validator.registerField(password, errorLabel: passwordErrorLabel, rules: [RequiredRule()])
        validator.registerField(passwordConfirm, errorLabel: confirmPasswordErrorLabel, rules: [RequiredRule(), ConfirmationRule(confirmField: password)])
    }
    
    func validationSuccessful() {
        // submit the form
        
        let currentUser = App.Memory.currentUserProfile.user
        
        currentUser.password = password.text!
        
        if App.Memory.passwordResetUser.resetingPassword == false {
        
            App.updatePassword()
            
        } else {
            // This is for users who have forgoten their password
            App.ResetPassword()
        }
        let alertController = UIAlertController(title: "Password reset", message: "You have successfully changed your password.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert) in
            
            if App.Memory.passwordResetUser.resetingPassword == false {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let swReveal = storyboard.instantiateViewControllerWithIdentifier("Landing Nav")
                
                UIApplication.sharedApplication().keyWindow?.rootViewController = swReveal
            }
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
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(TextField: UITextField) -> Bool {
        
        TextField.resignFirstResponder()
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        email.text = App.Memory.currentUserProfile.user.emailAddress
        Utilities.setButtonBorder(resetPasswordButton)
        
        password.delegate = self
        passwordConfirm.delegate = self
        
        passwordErrorLabel.hidden = true
        confirmPasswordErrorLabel.hidden = true
        
        setValidators()
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
