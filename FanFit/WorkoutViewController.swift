//
//  WorkoutViewController.swift
//  FanFit
//
//  Created by Gladwin Dosunmu on 17/09/2016.
//  Copyright © 2016 Almond Careers. All rights reserved.
//

import UIKit
import CoreLocation
import HealthKit

class WorkoutViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var milesLabel: UILabel!
    
    var zeroTime = NSTimeInterval()
    var timer : NSTimer = NSTimer()
    
    var minutes = UInt8()
    
    var seconds = UInt8()

    var distance = 0.0
    
    lazy var locationManager: CLLocationManager = {
        var _locationManager = CLLocationManager()
        _locationManager.delegate = self
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest
        _locationManager.activityType = .Fitness
        
        // Movement threshold for new events
        _locationManager.distanceFilter = 1.0
        return _locationManager
    }()
    
    lazy var locations = [CLLocation]()
    
    func updateValues() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        var timePassed: NSTimeInterval = currentTime - zeroTime
        minutes = UInt8(timePassed / 60.0)
        timePassed -= (NSTimeInterval(minutes) * 60)
        seconds = UInt8(timePassed)
        timePassed -= NSTimeInterval(seconds)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        timerLabel.text = "\(strMinutes):\(strSeconds)"
        
        distance = round(distance)
    
        let distanceQuantity = HKQuantity(unit: HKUnit.meterUnit(), doubleValue: distance)
        milesLabel.text = distanceQuantity.description
    }
    
    @IBAction func startTimer(sender: AnyObject) {
        
        timer.invalidate()
        zeroTime = NSDate.timeIntervalSinceReferenceDate()
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: #selector(WorkoutViewController.updateValues), userInfo: nil, repeats: true)
        
        distance = 0.0
        locations.removeAll(keepCapacity: false)
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func finishButtonTapped(sender: AnyObject) {
        
        timer.invalidate()
        locationManager.stopUpdatingLocation()
        
        var totalTime = NSTimeInterval()
        
        totalTime = NSTimeInterval(minutes * 60) + NSTimeInterval(seconds)
        let averageSpeed = round(distance / totalTime)
        
        App.Memory.currentWorkout.time = totalTime
        App.Memory.currentWorkout.distance = distance
        App.Memory.currentWorkout.averageSpeed = averageSpeed
        
        let alertController = UIAlertController(title: "Workout Complete", message: "Distance:\(distance)m\nTime:\(totalTime)s\n\(averageSpeed)m/s", preferredStyle: .Alert)
        
        alertController.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Utilities.setButtonBorder(startButton)
        Utilities.setButtonBorder(finishButton)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        locationManager.requestAlwaysAuthorization()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        timer.invalidate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

// MARK: - CLLocationManagerDelegate
extension WorkoutViewController: CLLocationManagerDelegate {
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for location in locations {
            if location.horizontalAccuracy < 20 {
                //update distance
                if self.locations.count > 0 {
                    distance += location.distanceFromLocation(self.locations.last!)
                }
                
                //save location
                self.locations.append(location)
            }
        }
    }
}
