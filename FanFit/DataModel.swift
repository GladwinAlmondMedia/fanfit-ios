//
//  DataModel.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 26/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import Foundation

class UserProfile : NSObject {
    
    var profileId = 0
    
    var user = User()
    
    var footballClub = FootballClub()
    
    var gender = ""
    
    var birthDate = NSDate()
    
    var weight = 0.0
    
    var address = Address()
    
    var activity = Activity()
    
    var allowedClubChange = true
    
    var profilePhoto = UIImage(named: "person-placeholder")
    
    var totalPoints = 0.0
}

class User : NSObject {
    
    var id = 0
    
    var emailAddress = ""
    
    var username = ""
    
    var password = ""
    
    var firstName = ""
    
    var lastName = ""
}

class FootballClub : NSObject {
    
    var id = 0
    
    var club = ""
}

class Address : NSObject {
    
    var id = 0
    
    var addressLine1 = ""
    
    var addressLine2 = ""
    
    var townCity = ""
    
    var county = ""
    
    var postcode = ""
}

class ActivityCategory : NSObject {
    
    var name : String = ""
    
    var image : UIImage = UIImage()
}


class Activity : NSObject {
    
    var id = 0
    
    var category = ActivityCategory()
    
    var footballClub = ""
    
    var title = ""
    
    var details = ""
    
    var startDate = NSDate()
    
    var endDate = NSDate()
    
    var prize = ""
    
}

class Workout : NSObject {
    
    var id = 0
    
    var activity = Activity()
    
    var totalTime = NSTimeInterval()
    
    var totalDistance = 0.0
    
    var averageSpeed = 0.0
    
    var totalCaloriesBurned = 0.0
    
    var pointsTally = 0.0
}

class Competition : NSObject {
    
    var id = 0
    
    var footballClub = FootballClub()
    
    var currentWalkingActivity = Activity()
    
    var currentRunningActivity = Activity()
    
    var currentCyclingActivity = Activity()
    
    var nextWalkingActivity = Activity()
    
    var nextRunningActivity = Activity()
    
    var nextCyclingActivity = Activity()
}

class ValidationErrors : NSObject {
    
    var login = false
}

class ActivityFitnessStats : NSObject {
    
    var totalPoints = 0.0
    
    var timeActive = NSTimeInterval()
    
    var distanceCovered = 0.0
    
    var averageSpeed = 0.0
    
    var caloriesBurned = 0.0
}













