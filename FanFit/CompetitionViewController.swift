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
    
    @IBOutlet weak var startWorkoutButton: UIButton!
    
    @IBOutlet weak var activityImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    let competitionDetails = [["Competition Details", "Greatest cumulative distance over the course of a week"], ["Start Date", "26th September 2016, 12:00"], ["Prize", "VIP tickets to home game."], ["Countdown", "4 days"], ["Top 3 Competitors", "1. Michael W\n2. John D\n3. Luke N"],["Points needed to top table", "15"]]
    
    let competitorDetails = [["Top 3 Competitors", "1.Michael W\n2.John D\n3.Luke N"],["Points needed to top table", "15"]]
    
    @IBAction func joinButtonTapped(sender: AnyObject) {
        
        let alertController = UIAlertController(title: "Join", message: "You have successfully joined this activity!", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        
        startWorkoutButton.hidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        Utilities.setButtonBorder(startWorkoutButton)
        
        self.activityBlurView.layer.cornerRadius = self.activityBlurView.frame.size.width / 2
        self.activityBlurView.clipsToBounds = true
        
        activityImage.image = App.Memory.currentActivityCategory.image
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = UIColor.clearColor()
        
        let competitionData = [competitionDetails, competitorDetails]
        
        startWorkoutButton.hidden = true
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
