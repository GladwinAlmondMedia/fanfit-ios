//
//  UserDashboardViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 02/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import Toast_Swift

class UserDashboardViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var startActivityButton: UIButton!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    var workoutsCache = NSCache()
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell\(indexPath.row)", forIndexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DashboardCollectionViewCell
        
        if let workouts = workoutsCache.objectForKey("workouts") {
            
            App.Memory.usersWorkouts = workouts as! [Workout]
            
            cell.updateUI(indexPath)
            
        } else {
            
            self.view.makeToastActivity(.Center)
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            App.getWorkouts { (success) in
                self.view.hideToastActivity()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                cell.updateUI(indexPath)
                
                self.workoutsCache.setObject(App.Memory.usersWorkouts, forKey: "workouts")
            }
            
        }
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        menuButton.target = self.revealViewController()
        
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        self.profileImageView.layer.cornerRadius = 10.0
        self.profileImageView.clipsToBounds = true
        
        let userProfile = App.Memory.currentUserProfile
        
        if let photoUrl : String? = userProfile.photoUrl {
            NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photoUrl!)!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                let image = UIImage(data: data!)
                
                dispatch_async(dispatch_get_main_queue(), {
                    App.Memory.currentUserProfile.profilePhoto = image
                    self.profileImageView.image = image
                })
            }).resume()
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        let userProfile = App.Memory.currentUserProfile
        //        if profileImageView.image!.isEqual(userProfile.profilePhoto) {
        //            print("yeeaaahh-------------------------------")
        profileImageView.image = userProfile.profilePhoto
        //            if let photoUrl : String? = userProfile.photoUrl {
        //                NSURLSession.sharedSession().dataTaskWithURL(NSURL(string: photoUrl!)!, completionHandler: { (data, response, error) in
        //                    if error != nil {
        //                        print(error!)
        //                        return
        //                    }
        //
        //                    let image = UIImage(data: data!)
        //
        //                    dispatch_async(dispatch_get_main_queue(), {
        //                        App.Memory.currentUserProfile.profilePhoto = image
        //                        self.profileImageView.image = image
        //                    })
        //                }).resume()
        //            }
        //        }
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
