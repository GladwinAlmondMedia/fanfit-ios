//
//  AppMemory.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 26/08/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import Foundation

class AppMemory {
    
    var currentUser = AppUser()
    
    func loginDummyUser() {
        
        currentUser.username = "jason_m"
        currentUser.title = "Mr"
        currentUser.firstName = "Jason"
        currentUser.lastName = "Mann"
        currentUser.gender = "Male"
        currentUser.birthDate = NSDate()
        currentUser.weight = 70
        currentUser.pointTally = 125
        currentUser.address.addressLine1 = "57 Clearance Street"
        currentUser.address.townCity = "Kingston"
        currentUser.address.postcode = "Kt5 9LA"
    }
    
    var updatingUser = false
    
    var currentActivityCategory = ActivityCategory()
    
    var currentWorkout = Workout()
    
}