//
//  ClubViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 08/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit

class ClubViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
//    var activities = ["Walking": [Activity](), "Running": [Activity](), "Cycling": [Activity]()]
    
    var upcomingActivities = [["Walking", Activity(), Activity()],["Cycling", Activity(), Activity()],["Running", Activity(), Activity()]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        
        menuButton.target = self.revealViewController()
        
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        if self.revealViewController() != nil {
            
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
            self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return upcomingActivities.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return upcomingActivities[section][0] as! String
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingActivities[section].count - 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("club-cell", forIndexPath: indexPath)
        
        let competition = App.Memory.competition
        
        var walkingUpcoming = upcomingActivities[0]
        
        walkingUpcoming[1] = competition.currentWalkingActivity
        walkingUpcoming[2] = competition.nextWalkingActivity
        
        upcomingActivities[0] = walkingUpcoming
        
        var cyclingUpcoming = upcomingActivities[1]
        
        cyclingUpcoming[1] = competition.currentCyclingActivity
        cyclingUpcoming[2] = competition.nextCyclingActivity
        
        upcomingActivities[1] = cyclingUpcoming
        
        var runningUpcoming = upcomingActivities[2]
        
        runningUpcoming[1] = competition.currentRunningActivity
        runningUpcoming[2] = competition.nextRunningActivity
        
        upcomingActivities[2] = runningUpcoming
        
        let cellActivity = upcomingActivities[indexPath.section][indexPath.row + 1] as! Activity
        
        cell.textLabel?.text = cellActivity.title
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.numberOfLines = 0
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.detailTextLabel?.text = cellActivity.details
        cell.detailTextLabel?.numberOfLines = 0
        
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
