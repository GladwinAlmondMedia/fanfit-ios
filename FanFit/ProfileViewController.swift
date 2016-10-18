//
//  ProfileViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 03/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import SimpleKeychain

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    var activeTime = ["Time Active (minutes):", ""]
    var distanceCovered = ["Distance Covered (miles):", ""]
    var averageSpeed = ["Average Speed (mins per mile):", ""]
    var caloriesBurned = ["Calories Burned (kcal):", ""]
    var pointsTally = ["Total Points Tally:", ""]
    
    var activityCells = [[String]]()

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var blurView: UIVisualEffectView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBAction func settingsButtonTapped(sender: AnyObject) {
        
        let actionSheetController: UIAlertController = UIAlertController(title: "Settings", message: "", preferredStyle: .ActionSheet)
        
        let cancelActionButton: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            
        }
        actionSheetController.addAction(cancelActionButton)
        
        let imageActionButton: UIAlertAction = UIAlertAction(title: "Upload Photo", style: .Default)
        { action -> Void in
            let ImagePicker = UIImagePickerController()
            ImagePicker.delegate = self
            ImagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(ImagePicker, animated: true, completion: nil)
        }
        actionSheetController.addAction(imageActionButton)
        
        let profileActionButton: UIAlertAction = UIAlertAction(title: "Profile Settings", style: .Default)
        { action -> Void in
            print("Profile")
            App.Memory.updatingUser = true
            self.performSegueWithIdentifier("profile-settings", sender: self)
        }
        actionSheetController.addAction(profileActionButton)
        
        let workoutActionButton: UIAlertAction = UIAlertAction(title: "Workout Settings", style: .Default)
        { action -> Void in
            print("Workout")
        }
        actionSheetController.addAction(workoutActionButton)
        
        let passwordActionButton: UIAlertAction = UIAlertAction(title: "Password Reset", style: .Default)
        { action -> Void in
            self.performSegueWithIdentifier("password-reset", sender: self)
        }
        actionSheetController.addAction(passwordActionButton)
        
        let changeClubActionButton: UIAlertAction = UIAlertAction(title: "Change Club", style: .Destructive)
        { action -> Void in
            print("Change club")
            App.Memory.updatingUser = true
            
            let alert = UIAlertController(title: "Warning", message: "This action can only be done once. Are you sure you would like to proceed?", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action) -> Void in
                
                self.dismissViewControllerAnimated(true, completion: nil)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Proceed", style: .Default, handler: { (action) -> Void in
                
                self.performSegueWithIdentifier("change-club", sender: self)
                
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
            
        }
        
        actionSheetController.addAction(changeClubActionButton)
        
        let logoutActionButton: UIAlertAction = UIAlertAction(title: "Logout", style: .Destructive)
        { action -> Void in
            // Remove token from keychain
            let keychain = A0SimpleKeychain(service: "Auth0")
            keychain.clearAll()
            App.Memory.currentUserProfile = UserProfile()
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let landingNav = storyboard.instantiateViewControllerWithIdentifier("Landing Nav")
            
            UIApplication.sharedApplication().keyWindow?.rootViewController = landingNav
            
            
        }
        actionSheetController.addAction(logoutActionButton)
        
        self.presentViewController(actionSheetController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            profileImageView.image = pickedImage
            App.Memory.currentUserProfile.profilePhoto = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.makeToastActivity(.Center)
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
        
        App.setActivityFitnessStats { (fitnessStats) in
            self.activeTime[1] = String(round(fitnessStats.timeActive))
            self.distanceCovered[1] = String(round(fitnessStats.distanceCovered))
            self.averageSpeed[1] = String(round(fitnessStats.averageSpeed))
            self.caloriesBurned[1] = String(round(fitnessStats.caloriesBurned))
            self.pointsTally[1] = String(round(fitnessStats.totalPoints))
            
            self.view.hideToastActivity()
            UIApplication.sharedApplication().endIgnoringInteractionEvents()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = UIColor.clearColor()
        
        activityCells += [pointsTally, activeTime, distanceCovered, averageSpeed, caloriesBurned]
        
        self.profileImageView.image = App.Memory.currentUserProfile.profilePhoto
        
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        
//        self.blurView.layer.cornerRadius = 10.0
//        self.blurView.clipsToBounds = true
        
        menuButton.target = self.revealViewController()
        
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityCells.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let currentUser = App.Memory.currentUserProfile.user
        
        return currentUser.firstName + " " + currentUser.lastName + " (\(currentUser.username))"
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("activity-cell", forIndexPath: indexPath)
        cell.textLabel?.text = activityCells[indexPath.row][0]
        cell.detailTextLabel?.text = activityCells[indexPath.row][1]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.textColor = UIColor.blackColor()
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    override func viewWillAppear(animated: Bool) {
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
