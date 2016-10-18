//
//  AppLogic.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 02/10/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import Foundation
import Alamofire
import SimpleKeychain

extension App {
    
    static func tokenAuth(username : String, password : String, completitionHandler : (success : Bool) -> Void) {
        // parameters will be username and password
        
        let url = "http://127.0.0.1:8000/api-token-auth/"
        
        let parameters = ["username" : username, "password" : password]
        
        let headers = ["Accept": "application/json"]
        
        let keychain = A0SimpleKeychain(service: "Auth0")
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                //                debugPrint(response)
                
                // will return token which I will save in keychain
                if let json = response.result.value {
                    
                    
                    if let token = json["token"] as? String {
                        
                        keychain.setString(token, forKey: "token")
                        
                        authenticateUser()
                        
                        completitionHandler(success: true)
                        
                        return
                    }
                    
                    completitionHandler(success: false)
                }
        }
        
    }
    
    static func authenticateUser() {
        
        let keychain = A0SimpleKeychain(service: "Auth0")
        
        let url = "http://127.0.0.1:8000/api/users/user-profile/"
        
        guard let token = keychain.stringForKey("token") else  {
            // User doesnt exist, user has to enter login details
            
            return
        }
        
        let headers = ["Accept": "application/json", "Authorization" : "Token \(token)"]
        
        Alamofire.request(.GET, url, encoding: .JSON, headers: headers)
            .responseJSON { response in
                //                debugPrint(response)
                
                if let userProfile = response.result.value {
                    // request gives user profile
                    
                    if (userProfile["detail"] as? String) == "Invalid token." {
                        return
                    }
                    
                    let currentUserProfile = App.Memory.currentUserProfile
                    
                    if let profileId = userProfile["id"] as? Int {
                        currentUserProfile.profileId = profileId
                    }
                    
                    if let weight = userProfile["weight"] as? Double {
                        currentUserProfile.weight = weight
                    }
                    
                    if let gender = userProfile["gender"] as? String {
                        currentUserProfile.gender = gender
                    }
                    
                    if let totalPoints = userProfile["total_points"] as? String {
                        currentUserProfile.totalPoints = Double(totalPoints)!
                    }
                    
                    //                    if let profilePhoto = userProfile["photo"] as? NSData{
                    //                    }
                    if let user = userProfile["user"] {
                        let currentUser = currentUserProfile.user
                        
                        if let id = user?["id"] as? Int{
                            
                            currentUser.id = id
                        }
                        
                        if let email = user?["email"] as? String {
                            
                            currentUser.emailAddress = email
                        }
                        
                        if let username = user?["username"] as? String {
                            currentUser.username = username
                        }
                        
                        if let firstName = user?["first_name"] as? String {
                            currentUser.firstName = firstName
                        }
                        
                        if let lastName = user?["last_name"] as? String {
                            currentUser.lastName = lastName
                        }
                    }
                    
                    if let address = userProfile["address"] {
                        let currentAddress = currentUserProfile.address
                        
                        if let id = address?["id"] as? Int {
                            currentAddress.id = id
                        }
                        
                        if let addressLine1 = address?["address_line_1"] as? String {
                            currentAddress.addressLine1 = addressLine1
                        }
                        
                        if let addressLine2 = address?["address_line_2"] as? String {
                            currentAddress.addressLine2 = addressLine2
                        }
                        
                        if let county = address?["county"] as? String {
                            currentAddress.county = county
                        }
                        
                        if let townCity = address?["town_city"] as? String {
                            currentAddress.townCity = townCity
                        }
                        
                        if let postcode = address?["postcode"] as? String {
                            currentAddress.postcode = postcode
                        }
                    }
                    
                    if let activity = userProfile["activity"] {
                        
                        let currentActivity = currentUserProfile.activity
                        
                        if let id = activity?["id"] as? Int {
                            currentActivity.id = id
                        }
                    }
                    
                    if let allowedClubChange = userProfile["allowed_club_change"] as? Bool {
                        currentUserProfile.allowedClubChange = allowedClubChange
                    }
                    
                    if let birthdate_string = userProfile["birth_date"] as? String {
                        let birthdate = self.getDateFromString(birthdate_string)
                        currentUserProfile.birthDate = birthdate
                    }
                    
                    if let footballClub = userProfile["football_club"] {
                        
                        let currentFootballClub = currentUserProfile.footballClub
                        
                        if let id = footballClub?["id"] as? Int {
                            currentFootballClub.id = id
                        }
                        
                        if let club = footballClub?["club"] as? String {
                            currentFootballClub.club = club
                        }
                    }
                    
                    App.getCompetition()
                    
                    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
                    let swReveal = storyboard.instantiateViewControllerWithIdentifier("SWReveal")
                    
                    UIApplication.sharedApplication().keyWindow?.rootViewController = swReveal
                    
                } else {
                    // request failed (Probably invalid token)
                    // So show login screen and login user
                    
                }
        }
        
    }
    
    static func createAccount(completionHandler : (success : Bool) -> Void) {
        
        let url = "http://127.0.0.1:8000/api/users/create-profile/"
        
        var parameters = [String : AnyObject]()
        
        let newUserProfile = App.Memory.currentUserProfile
        
        let newUser = newUserProfile.user
        
        //        newUser.username = "test_user6"
        //        newUser.password = "password123"
        //        newUser.emailAddress = "tes6t@email.com"
        //        newUser.firstName = "Test"
        //        newUser.lastName = "User"
        
        let userParams = ["email" : newUser.emailAddress, "username" : newUser.username, "password" : newUser.password, "first_name" : newUser.firstName, "last_name" : newUser.lastName]
        
        let  newAddress = newUserProfile.address
        
        //        newAddress.addressLine1 = "20 Grove Lea"
        //        newAddress.townCity = "Hatfield"
        //        newAddress.postcode = "Al10 8LA"
        
        let addressParams = ["address_line_1" : newAddress.addressLine1, "address_line_2" : newAddress.addressLine2, "town_city" : newAddress.townCity, "county" : newAddress.county, "postcode" : newAddress.postcode]
        
        //        newUserProfile.footballClub.club = "Manchester United"
        
        let clubParams = ["club" : newUserProfile.footballClub.club]
        
        //        newUserProfile.gender = "Female"
        //        newUserProfile.birthDate = NSDate()
        
        parameters = ["user" : userParams, "address" : addressParams, "gender" : newUserProfile.gender, "birth_date" : dateToJsonString(newUserProfile.birthDate) , "weight" : newUserProfile.weight, "football_club" : clubParams]
        
        let headers = ["Accept": "application/json"]
        
        Alamofire.request(.POST, url, parameters: parameters, encoding: .JSON, headers: headers)
            .responseJSON { response in
                //                debugPrint(response)
                
                // Write validations for email, username and password
        }
    }
    
    static func setFootballClubs() {
        let url = "http://127.0.0.1:8000/api/competition/football-clubs/"
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            //            debugPrint(response)
            
            if let data = response.data {
                
                App.Memory.allFootballClubs = []
                var allFootballClubs = App.Memory.allFootballClubs
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                    
                    for dict in json! {
                        
                        let newClub = FootballClub()
                        
                        if let id = dict["id"] as? Int {
                            newClub.id = id
                        }
                        if let club = dict["club"] as? String {
                            newClub.club = club
                        }
                        
                        allFootballClubs.append(newClub)
                    }
                    
                    App.Memory.allFootballClubs = allFootballClubs
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    static func getWorkouts(completionHandler : (success : Bool) -> Void) {
        
        let currentUserProfile = App.Memory.currentUserProfile
        
        // url takes USER id as parameter
        
        let url = "http://127.0.0.1:8000/api/competition/workouts/\(currentUserProfile.user.id)/"
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            //            debugPrint(response)
            
            if let data = response.data {
                
                App.Memory.usersWorkouts = []
                var allWorkouts = App.Memory.usersWorkouts
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [[String : AnyObject]]
                    
                    for dict in json! {
                        
                        let newWorkout = Workout()
                        
                        if let id = dict["id"] as? Int {
                            newWorkout.id = id
                        }
                        if let totalTime = dict["total_time"] as? String {
                            newWorkout.totalTime = NSTimeInterval(totalTime)!
                        }
                        if let totalDistance = dict["total_distance"] as? String {
                            newWorkout.totalDistance = Double(totalDistance)!
                        }
                        if let averageSpeed = dict["average_speed"] as? String {
                            newWorkout.averageSpeed = Double(averageSpeed)!
                        }
                        if let totalCaloriesBurned = dict["total_calories_burned"] as? String {
                            newWorkout.totalCaloriesBurned = Double(totalCaloriesBurned)!
                        }
                        if let pointsTally = dict["points_tally"] as? String {
                            newWorkout.pointsTally = Double(pointsTally)!
                        }
                        
                        if let activity = dict["activity"] {
                            let newActivity = newWorkout.activity
                            
                            if let activityCategory = activity["category"] {
                                let newCategory = ActivityCategory()
                                
                                if let categoryName = activityCategory?["category"] as? String {
                                    newCategory.name = categoryName
                                    newActivity.category = newCategory
                                }
                                
                                if let title = activity["title"] as? String {
                                    newActivity.title = title
                                }
                                
                                if let id = activity["id"] as? Int {
                                    newActivity.id = id
                                    
                                }
                            }
                            
                            newWorkout.activity = newActivity
                        }
                        
                        allWorkouts.append(newWorkout)
                    }
                    
                    App.Memory.usersWorkouts = allWorkouts
                    
                    completionHandler(success: true)
                }
                catch {
                    print(error)
                    completionHandler(success: false)
                }
            }
        }
    }
    
    static func getCompetition() {
        
        let currentUserProfile = App.Memory.currentUserProfile
        
        // Takes football club id as arguement to get all activities for that specific club
        
        let url = "http://127.0.0.1:8000/api/competition/club/\(currentUserProfile.footballClub.id)/"
        
        Alamofire.request(.GET, url).responseJSON { (response) in
            //            debugPrint(response)
            
            if let data = response.data {
                
                var competition = App.Memory.competition
                
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String : AnyObject]
                    
                    if let id = json?["id"] as? Int {
                        competition.id = id
                    }
                    if let footballClub = json?["football_club"] {
                        
                        if let id = footballClub["id"] as? Int {
                            competition.footballClub.id = id
                        }
                        
                        if let club = footballClub["club"] as? String {
                            competition.footballClub.club = club
                        }
                    }
                    
                    var allActivities : [(Activity, AnyObject)] = []
                    
                    if let currentWalking = json?["current_walking_activity"] {
                        
                        let tuple = (competition.currentWalkingActivity,currentWalking)
                        
                        allActivities.append(tuple)
                    }
                    
                    if let currentRunning = json?["current_running_activity"] {
                        let tuple = (competition.currentRunningActivity,currentRunning)
                        allActivities.append(tuple)
                    }
                    
                    if let currentCycling = json?["current_cycling_activity"] {
                        let tuple = (competition.currentCyclingActivity,currentCycling)
                        allActivities.append(tuple)
                    }
                    
                    if let nextWalking = json?["next_walking_activity"] {
                        let tuple = (competition.nextWalkingActivity,nextWalking)
                        allActivities.append(tuple)
                    }
                    
                    if let nextRunning = json?["next_running_activity"] {
                        let tuple = (competition.nextRunningActivity,nextRunning)
                        allActivities.append(tuple)
                    }
                    
                    if let nextCycling = json?["next_cycling_activity"] {
                        let tuple = (competition.nextCyclingActivity,nextCycling)
                        allActivities.append(tuple)
                    }
                    
                    
                    for activity in allActivities {
                        
                        let newActivity = activity.0
                        
                        let activityJson = activity.1
                        
                        if let id = activityJson["id"] as? Int {
                            newActivity.id = id
                        }
                        if let category = activityJson["category"] {
                            if let name = category?["category"] as? String {
                                newActivity.category.name = name
                            }
                        }
                        if let title = activityJson["title"] as? String {
                            newActivity.title = title
                            
                        }
                        if let details = activityJson["details"] as? String {
                            newActivity.details = details
                        }
                        if let startDateString = activityJson["start_date"] as? String {
                            newActivity.startDate = self.getDateFromString(startDateString)
                        }
                        if let endDateString = activityJson["end_date"] as? String {
                            newActivity.endDate = self.getDateFromString(endDateString)
                        }
                        if let prize = activityJson["prize"] as? String {
                            newActivity.prize = prize
                        }
                    }
                    
                    //                        allFootballClubs.append(newClub)
                    
                    
                    //                    App.Memory.allFootballClubs = allFootballClubs
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
    static func setActivityFitnessStats(completionHandler : (fitnessStats : ActivityFitnessStats) -> Void) {
        
        let userWorkouts = App.Memory.usersWorkouts
        
        let currentUserProfile = App.Memory.currentUserProfile
        
        let userActivity = currentUserProfile.activity
        
        let activityFitnessStats = App.Memory.activityFitnessStats
        var counter = 0.0
        
        for workout in userWorkouts {
            
            if workout.activity.id == userActivity.id {
                
                counter += 1
                activityFitnessStats.timeActive += workout.totalTime
                activityFitnessStats.distanceCovered += workout.totalDistance
                activityFitnessStats.averageSpeed += workout.averageSpeed
                activityFitnessStats.caloriesBurned += workout.totalCaloriesBurned
            }
        }
        
        activityFitnessStats.totalPoints = currentUserProfile.totalPoints
        
        activityFitnessStats.timeActive /= counter
        activityFitnessStats.distanceCovered /= counter
        activityFitnessStats.averageSpeed /= counter
        activityFitnessStats.caloriesBurned /= counter
        
        completionHandler(fitnessStats: activityFitnessStats)
        
    }
    
    static func caloriesBurned(time: NSTimeInterval) -> Double {
        
        let weight = App.Memory.currentUserProfile.weight
        let timeHours = time / 3600.0
        var MetValue = 0.0
        
        let currentActivityCategory = App.Memory.currentActivityCategory.name
        
        switch currentActivityCategory {
        case "Walking":
            MetValue = 3.8
        case "Running":
            MetValue = 7.5
        case "Cycling":
            MetValue = 8.0
        default:
            MetValue = 7.5
        }
        
        let caloriesBurned = weight*MetValue*timeHours
        
        return caloriesBurned
    }
    
    static func getDateFromString(string: String) -> NSDate {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssz"
        
        if let dateString = dateFormatter.dateFromString(string) {
            return dateString
        }
        
        let calendar = NSCalendar.currentCalendar()
        let twoDaysAgo = calendar.dateByAddingUnit(.Day, value: -2, toDate: NSDate(), options: [])
        return twoDaysAgo!
        
    }
    
    static func dateToJsonString(date: NSDate) -> String {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.stringFromDate(date)
    }
}
