//
//  LandingViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 15/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {

    @IBOutlet weak var createProfileButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        Utilities.setButtonBorder(createProfileButton)
        Utilities.setButtonBorder(loginButton)
        
        App.Memory.updatingUser = false
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
