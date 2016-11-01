//
//  AppMemory.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 26/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import Foundation

class AppMemory {
    
    var currentUserProfile = UserProfile()
    
    var updatingUser = false
    
    var currentActivityCategory = ActivityCategory()
    
    var currentWorkout = Workout()
    
    var validationErrors = ValidationErrors()
    
    var allFootballClubs = [FootballClub]()
    
    var usersWorkouts = [Workout]()
    
    var activityFitnessStats = ActivityFitnessStats()
    
    var competition = Competition()
    
    var chosenActivity = Activity()
    
    var topCompetitors = TopCompetitors()
    
    var passwordResetUser = PasswordResetUser()
    
    let apiUrl = "http://fan-fit.eu-west-1.elasticbeanstalk.com"
}
