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
    
    //    var myCollectionViewHeight: CGFloat = 0.0 {
    //        didSet {
    //            if myCollectionViewHeight != oldValue {
    //                collectionView.collectionViewLayout.invalidateLayout()
    //                collectionView.collectionViewLayout.prepareLayout()
    //            }
    //        }
    //    }
    //
    //    override func viewDidLayoutSubviews() {
    //        myCollectionViewHeight = collectionView.bounds.size.height
    //    }
    //
    //    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    //        return CGSize(width: 190, height: myCollectionViewHeight)
    //    }
    //
    //
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        //        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell\(indexPath.row)", forIndexPath: indexPath)
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! DashboardCollectionViewCell
                    
            self.view.makeToastActivity(.Center)
            
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            App.getWorkouts { (success) in
                self.view.hideToastActivity()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
                cell.updateUI(indexPath)
                
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
        
    }
    
    override func viewWillAppear(animated: Bool) {
        profileImageView.image = App.Memory.currentUserProfile.profilePhoto
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
