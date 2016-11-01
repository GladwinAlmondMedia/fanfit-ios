//
//  OverviewCollectionViewCell.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 02/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let dataSource = [[String]]()
    
    let dashboardImagesNames = ["Running-100","Leaderboard-100", "Stopwatch-100"]
    
//    var overviewLabels = ["Points tally:", "", "Points till No'1: 15"]
//    
//    var top3Labels = ["1. Michael W", "2. John D", "3. Luke N"]
//    
//    var FitnessHistoryLabels = ["", "", ""]
    
    var dashboardCellLabels = [[String]]()
    
    let dashboardTitles = ["Overview", "Top 3 Competitors", "Competition History"]
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var overviewImageView: UIImageView!
    
    @IBOutlet weak var dashboardcellTitle: UILabel!
    
//    @IBOutlet weak var viewMoreButton: UIButton!
//    
//    @IBOutlet weak var label1: UILabel!
//    
//    @IBOutlet weak var label2: UILabel!
//    
//    @IBOutlet weak var label3: UILabel!
    
    var dashboardCell = [String]()
    
    func updateUI(indexPath: NSIndexPath) {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        
        
        // 2nd collection view
        
        let topCompetitors = App.Memory.topCompetitors
        
        let firstUser = topCompetitors.first
        let secondUser = topCompetitors.second
        let thirdUser = topCompetitors.third
        
        let firstUserCell = ["1st - " + firstUser.username, "\(firstUser.userPoints) points"]
        let secondUserCell = ["2nd - " + secondUser.username, "\(secondUser.userPoints) points"]
        let thirdUserCell = ["3rd - " + thirdUser.username, "\(thirdUser.userPoints) points"]
        
        
        // 1st collection view
        let userProfile = App.Memory.currentUserProfile
        
        let usernameInfo = [userProfile.user.username, userProfile.user.firstName + " " + userProfile.user.lastName]
        let pointsInfo = ["Poins for current activity", String(userProfile.totalPoints)]
        
        var points = firstUser.userPoints - userProfile.totalPoints
        
        if points < 0 {
            points = 0
        }
        
        let pointsTillNumberOne = ["Points till no'1", String(points)]
        
        // 3rd collection view
        
        let fitnessHistory = App.Memory.usersWorkouts
        dashboardCellLabels = []
        switch indexPath.row {
        case 0:
            dashboardCellLabels.append(usernameInfo)
            dashboardCellLabels.append(pointsInfo)
            dashboardCellLabels.append(pointsTillNumberOne)
        case 1:
            dashboardCellLabels.append(firstUserCell)
            dashboardCellLabels.append(secondUserCell)
            dashboardCellLabels.append(thirdUserCell)
        case 2:
            for workout in fitnessHistory {
                dashboardCellLabels.append([workout.activity.title, String(workout.pointsTally) + " points"])
            }
        default:
            dashboardCellLabels.append(firstUserCell)
            dashboardCellLabels.append(secondUserCell)
            dashboardCellLabels.append(thirdUserCell)
        }
        
        dashboardcellTitle.text = dashboardTitles[indexPath.row]
        
        self.overviewImageView.image = UIImage(named: dashboardImagesNames[indexPath.row])
        
        self.layer.cornerRadius = 7.0
        
        tableView.tableFooterView = UIView()
        
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.reloadData()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dashboardCellLabels.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 71
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("dashboard-cell", forIndexPath: indexPath)
        
        cell.textLabel?.text = "Test"
        cell.layoutMargins = UIEdgeInsetsZero
        cell.separatorInset = UIEdgeInsetsZero
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.detailTextLabel?.font = UIFont.systemFontOfSize(15)
        
//        switch indexPath.row {
//        case 0:
//            cell.textLabel?.text = dashboardCellLabels[0][0]
//            cell.detailTextLabel?.text = dashboardCellLabels[0][1]
//        case 1:
//            cell.textLabel?.text = dashboardCellLabels[1][0]
//            cell.detailTextLabel?.text = dashboardCellLabels[1][1]
//        case 2:
//            cell.textLabel?.text = dashboardCellLabels[2][0]
//            cell.detailTextLabel?.text = dashboardCellLabels[2][1]
//        default:
//            cell.textLabel?.text = dashboardCellLabels[0][0]
//            cell.detailTextLabel?.text = dashboardCellLabels[0][1]
//        }
        
        cell.textLabel?.text = dashboardCellLabels[indexPath.row][0]
        cell.detailTextLabel?.text = dashboardCellLabels[indexPath.row][1]
        
        return cell
    }
    
}

















