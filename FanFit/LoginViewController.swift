//
//  LoginViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 26/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SwiftValidator

class LoginViewController: UIViewController, ValidationDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var createProfileButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    
    @IBAction func forgotPasswordButtonTapped(sender: UIButton) {
        
        let alertController = UIAlertController(title: "Password Reset", message: "Enter your email address", preferredStyle: UIAlertControllerStyle.Alert)
        
        let sendAction = UIAlertAction(title: "Send", style: UIAlertActionStyle.Default) { (alert) in
            
            let emailTextField = alertController.textFields![0] as UITextField
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
            let alertController2 = UIAlertController(title: "Password reset", message: "We have sent an email to \(emailTextField.text!) to reset your password", preferredStyle: UIAlertControllerStyle.Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
            
            alertController2.addAction(okAction)
            self.presentViewController(alertController2, animated: true, completion: nil)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default) { (alert) in
            
        }
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Enter email"
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(sendAction)
        
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    
    let validator = Validator()
    
    func setValidators() {
        
        validator.registerField(username, rules: [RequiredRule()])
        validator.registerField(password, rules: [RequiredRule()])
    }
    
    func validationSuccessful() {
        // submit the form
        
        App.tokenAuth(username.text!, password: password.text!) { (success) in
            if success == true {
                
                let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                let swReveal = storyboard.instantiateViewControllerWithIdentifier("SWReveal")
            
                UIApplication.sharedApplication().keyWindow?.rootViewController = swReveal
            } else {
                self.errorLabel.hidden = false
            }
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
    @IBAction func loginButtonPressed(sender: AnyObject) {
        errorLabel.hidden = true
        
        username.layer.borderColor = UIColor.clearColor().CGColor
        password.layer.borderColor = UIColor.clearColor().CGColor
        
        validator.validate(self)
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        Utilities.setButtonBorder(loginButton)
        Utilities.setButtonBorder(forgotPasswordButton)
        Utilities.setButtonBorder(createProfileButton)
        
        setValidators()
        
        errorLabel.hidden = true
        
        App.authenticateUser()
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
