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
    
    let upcomingActivities = [["Walking","Greatest cumulative calorie burn over the course of a week", "Greatest cumulative distance over the course of a week"],["Cycling", "Greatest cumulative distance over the course of a week", "Greatest cumulative time over the course of a week"],["Running", "Furthest distance by running daily for 1hour cumulatively"]]
    
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
        return upcomingActivities[section][0]
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingActivities[section].count - 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 88
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("club-cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = upcomingActivities[indexPath.section][indexPath.row + 1]
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.numberOfLines = 0
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
