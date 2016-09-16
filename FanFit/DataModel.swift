//
//  DataModel.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 26/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import Foundation

class AppUser : NSObject {
    
    var footballClub = ""
    
    var title = ""
    
    var firstName = ""
    
    var lastName = ""
    
    var gender = ""
    
    var birthDate = NSDate()
    
    var weight = 0
    
    var address = Address()
    
    var emailAddress = ""
    
    var username = ""
    
    var password = ""
    
    var profilePhoto = UIImage(named: "person-placeholder")
    
    var pointTally = 0
}

class Address : NSObject {
    
    var addressLine1 = ""
    
    var addressLine2 = ""
    
    var townCity = ""
    
    var county = ""
    
    var postcode = ""
}

class Activity : NSObject {
    
    var id : Int = 0
    
    var category : String = ""
    
    var title : String = ""
    
    var start_date : NSDate = NSDate()
    
    var end_date : NSDate = NSDate()
    
    var competitors : [String] = []
    
    var prize : String = ""
    
    var activityCategory : String = ""
}

class ActivityCategory : NSObject {
    
    var name : String = ""
    
    var image : UIImage = UIImage()
}


















