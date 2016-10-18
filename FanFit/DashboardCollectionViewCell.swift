//
//  OverviewCollectionViewCell.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 02/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
    
    let dashboardImagesNames = ["Running-100","Leaderboard-100", "Stopwatch-100"]
    
    var overviewLabels = ["Points tally:", "125", "Points till No'1: 15"]
    
    var top3Labels = ["1. Michael W", "2. John D", "3. Luke N"]
    
    var FitnessHistoryLabels = ["Running: 25 points", "Walking: 57 points", "Cycling: 29 points"]
    
    var dashboardCellLabels = [[],[],[]]
    
    let dashboardTitles = ["Overview", "Top 3 Competitors", "Fitness History"]
    
    @IBOutlet weak var overviewImageView: UIImageView!
    
    @IBOutlet weak var dashboardcellTitle: UILabel!
    
    @IBOutlet weak var viewMoreButton: UIButton!
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var label3: UILabel!
    
    func updateUI(indexPath: NSIndexPath) {
        
        // Points tally
        overviewLabels[1] = String(App.Memory.currentUserProfile.totalPoints)
        FitnessHistoryLabels = ["","",""]
        
        if indexPath.row == 2 {
            let usersWorkouts = App.Memory.usersWorkouts
            
            FitnessHistoryLabels[0] = "\(usersWorkouts[0].activity.category.name): \(usersWorkouts[0].pointsTally)"
            FitnessHistoryLabels[1] = "\(usersWorkouts[1].activity.category.name): \(usersWorkouts[1].pointsTally)"
            FitnessHistoryLabels[2] = "\(usersWorkouts[2].activity.category.name): \(usersWorkouts[2].pointsTally)"
        }
        
        dashboardCellLabels[0] = overviewLabels
        dashboardCellLabels[1] = top3Labels
        dashboardCellLabels[2] = FitnessHistoryLabels
        
        
        dashboardcellTitle.text = dashboardTitles[indexPath.row]
        
        label1.text = dashboardCellLabels[indexPath.row][0] as? String
        label2.text = dashboardCellLabels[indexPath.row][1] as? String
        
        // Editing label for points tally
        if indexPath.row == 0 {
            
            label2.font = label2.font.fontWithSize(45)
            label2.textAlignment = .Center
            label2.textColor = UIColor.blackColor()
        }
        label3.text = dashboardCellLabels[indexPath.row][2] as? String
        
        if indexPath.row != 2 {
            viewMoreButton.hidden = true
        }
        
        self.overviewImageView.image = UIImage(named: dashboardImagesNames[indexPath.row])
        
        self.layer.cornerRadius = 7.0
        
    }
    
}
