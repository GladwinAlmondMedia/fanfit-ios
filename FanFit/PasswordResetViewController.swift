//
//  PasswordResetViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 04/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class PasswordResetViewController: UIViewController, ValidationDelegate {

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
        
        let alertController = UIAlertController(title: "Password reset", message: "Your password has been reset successfully", preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default) { (alert) in
            self.navigationController?.popViewControllerAnimated(true)
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        Utilities.setButtonBorder(resetPasswordButton)
        
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
