//
//  CompetitionViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 15/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit

class CompetitionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var activityBlurView: UIVisualEffectView!
    
    @IBOutlet weak var joinButton: UIBarButtonItem!
    
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var competitionDetails = [[String]]()
    
    //    let competitorDetails = [["Top 3 Competitors", "1.Michael W\n2.John D\n3.Luke N"],["Points needed to top table", "15"]]
    
    
    @IBAction func joinButtonTapped(sender: AnyObject) {
        // Check competition has started, return alert
        
        let profileActivity = App.Memory.currentUserProfile.activity
        let chosenActivity = App.Memory.chosenActivity
        
        var title = ""
        var message = ""
        
        if profileActivity.id == chosenActivity.id {
            App.Memory.currentUserProfile.activity = Activity()
            App.Memory.currentUserProfile.totalPoints = 0.0
            title = "Leave"
            message = "You have successfully left this activity!"
            startWorkoutButton.hidden = true
            joinButton.title = "Join"
        } else {
            App.Memory.currentUserProfile.activity = chosenActivity
            title = "Join"
            message = "You have successfully joined this activity!"
            startWorkoutButton.hidden = false
            joinButton.title = "Leave"
        }
        App.updateUserProfile()
        App.getTopCompetitors()
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        Utilities.setButtonBorder(startWorkoutButton)
        
        self.activityBlurView.layoutIfNeeded()
        self.activityBlurView.layer.cornerRadius = self.activityBlurView.frame.size.width / 2
        self.activityBlurView.clipsToBounds = true
        
        activityImage.image = App.Memory.currentActivityCategory.image
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor.clearColor()
        
        let currentUserProfile = App.Memory.currentUserProfile
        
        let chosenActivity = App.Memory.chosenActivity
        
        //        let competitionData = [competitionDetails, competitorDetails]
        
        startWorkoutButton.hidden = true
        
        if currentUserProfile.activity.id == chosenActivity.id {
            joinButton.title = "Leave"
            startWorkoutButton.hidden = false
        }
        
        let compTitle = ["Competition Titile", chosenActivity.title]
        competitionDetails.append(compTitle)
        
        let compDetails = ["Competition Details", chosenActivity.details]
        competitionDetails.append(compDetails)
        
        let compStartDate = ["Start Date", Utilities.myDateTimeFormatter(chosenActivity.startDate)]
        competitionDetails.append(compStartDate)
        
        let compPrize = ["Prize", chosenActivity.prize]
        competitionDetails.append(compPrize)
        
        if NSDate().compare(chosenActivity.startDate) == NSComparisonResult.OrderedDescending || NSDate().compare(chosenActivity.startDate) == NSComparisonResult.OrderedSame {
            
            if NSDate().compare(chosenActivity.endDate) == NSComparisonResult.OrderedAscending {
                
                let daysLeft = Utilities.daysBetweenDates(NSDate(), date2: chosenActivity.endDate)
                let countdown = ["Countdown", "\(daysLeft) days left"]
                competitionDetails.append(countdown)
                
                let topCompetitors = App.Memory.topCompetitors
                
                let firstUser = topCompetitors.first
                
                var firstUserString = ""
                
                if firstUser.username != "" {
                    
                    firstUserString = firstUser.username + " - " + String(firstUser.userPoints)
                }
                
                let secondUser = topCompetitors.second
              
                var secondUserString = ""
                
                if secondUser.username != "" {
                    
                    secondUserString = secondUser.username + " - " + String(secondUser.userPoints)
                }
                
                let thirdUser = topCompetitors.third
               
                var thirdUserString = ""
                
                if thirdUser.username != "" {
                    
                    thirdUserString = thirdUser.username + " - " + String(thirdUser.userPoints)
                }
                
                if currentUserProfile.activity.id != 0 {
                    let top3 = ["Top 3 Competitors", "1. \(firstUserString)\n2. \(secondUserString)\n3. \(thirdUserString)"]
                    competitionDetails.append(top3)
                }
                
                let pointsToTop = ["Points needed to top table", String(firstUser.userPoints - currentUserProfile.totalPoints)]
                competitionDetails.append(pointsToTop)
                
            } else {
                let compWarning = ["This competition has ended!", ""]
                competitionDetails.append(compWarning)
                self.navigationItem.rightBarButtonItem = nil
            }
        } else {
            let compWarning = ["This competition hasn't started yet!", ""]
            competitionDetails.append(compWarning)
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return App.Memory.currentActivityCategory.name
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return competitionDetails.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("competition-cell", forIndexPath: indexPath)
        cell.textLabel?.text = competitionDetails[indexPath.row][0]
        cell.detailTextLabel?.text = competitionDetails[indexPath.row][1]
        cell.textLabel?.textColor = UIColor.whiteColor()
        
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(17)
        
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
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
