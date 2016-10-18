//
//  ChooseActivityViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 15/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit

class ChooseActivityViewController: UIViewController {
    
    //PREVENT USER FROM JOINING A NEW ACTIVITY IF ALREADY JOINED ONE
    // DISPLAY MESSAGE SAYING ALREADY JOINED AN ACTIVITY AND MUST LEAVE OTHER ACTVITY TO JOIN ANOTHER ONE

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var runningBlurView: UIVisualEffectView!
    
    @IBOutlet weak var walkingBlurView: UIVisualEffectView!
    
    @IBOutlet weak var cyclingBlurView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        menuButton.target = self.revealViewController()
        
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.runningBlurView.layoutIfNeeded()
        self.runningBlurView.layer.cornerRadius = self.runningBlurView.frame.size.width / 2
        self.runningBlurView.clipsToBounds = true
        
        self.walkingBlurView.layoutIfNeeded()
        self.walkingBlurView.layer.cornerRadius = self.walkingBlurView.frame.size.width / 2
        self.walkingBlurView.clipsToBounds = true
        
        self.cyclingBlurView.layoutIfNeeded()
        self.cyclingBlurView.layer.cornerRadius = self.cyclingBlurView.frame.size.width / 2
        self.cyclingBlurView.clipsToBounds = true
        
        let runningRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChooseActivityViewController.viewTapped(_:)))
        
        let walkingRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChooseActivityViewController.viewTapped(_:)))
        
        let cyclingRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChooseActivityViewController.viewTapped(_:)))
        
        runningBlurView.userInteractionEnabled = true
        runningBlurView.addGestureRecognizer(runningRecognizer)
        
        walkingBlurView.userInteractionEnabled = true
        walkingBlurView.addGestureRecognizer(walkingRecognizer)
        
        cyclingBlurView.userInteractionEnabled = true
        cyclingBlurView.addGestureRecognizer(cyclingRecognizer)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func viewTapped(gestureRecognizer: UITapGestureRecognizer) {
        //tappedImageView will be the image view that was tapped.
        //dismiss it, animate it off screen, whatever.
        let tappedImageView = gestureRecognizer.view!
        
        let activityCategory = ActivityCategory()
        
        switch tappedImageView {
        case runningBlurView:
            activityCategory.name = "Running"
            activityCategory.image = UIImage(named: "Running-100")!
        case walkingBlurView:
            activityCategory.name = "Walking"
            activityCategory.image = UIImage(named: "Walking-100")!
        case cyclingBlurView:
            activityCategory.name = "Cycling"
            activityCategory.image = UIImage(named: "Cycling-100")!
        default:
            activityCategory.name = "Running"
            activityCategory.image = UIImage(named: "Running-100")!
        }
        
        App.Memory.currentActivityCategory = activityCategory
                
        performSegueWithIdentifier("chose-activity", sender: self)
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
