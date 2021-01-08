//
//  MapInterfaceController.swift
//  Street Guardian WatchKit Extension
//
//  Created by Konstantinos Pytharoulios on 20/11/20.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

class HomeViewController: UIViewController, CLLocationManagerDelegate{
    
    
    
   
    
    
    
    
    var locationManager = CLLocationManager()
    
    var userLocationInfoSTART = [String]()
    var userLocationInfoEND = ["0","0","0","0"]
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let locationArray = locations as NSArray
        
        let location = locationArray.lastObject as! CLLocation
        
        userLocationInfoSTART.removeAll(keepingCapacity: true)
        userLocationInfoSTART.append("\(location.coordinate.latitude)")
        userLocationInfoSTART.append("\(location.coordinate.longitude)")
        userLocationInfoSTART.append("\(location.speed)")
        userLocationInfoSTART.append("\(location.timestamp)")
        
        
        // Here we are calling the function which checks the changing of the speeds.
        // If we detect a big changing we are going to trigger alarms.
        
        if checkRateOfChange(speedStart: userLocationInfoEND[2], speedEnd: userLocationInfoSTART[2]){
            // True: The case that an abnormal changing of speed was detected
            
            [self.locationManager .stopUpdatingLocation()]
            //pushController(withName: "warningInterfaceController", context: "fromMapInterface")
        }
        else{
           // FALSE: EVERYTHING SEEMS FINE WITH THE SPEED
        }
      
        
        print(userLocationInfoEND)
        print(userLocationInfoSTART)
        print("\n\n")
        
        // Speed before, becomes speed after.
        userLocationInfoEND = userLocationInfoSTART
        
        
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span )
        
        map.setRegion(region)
        
    }
    
    

    
    // This is the function which checks the changing of speed.
    // Returns TRUE: When is has detected an abnormal changing in speed.
    // Returns FALSE: When everything seems ok.
    func checkRateOfChange(speedStart:String, speedEnd:String) -> Bool{
        
        let doubleSpeedStart = Double(speedStart)
        let doubleSpeedEnd = Double(speedEnd)
        
        if doubleSpeedStart! > 30.0 {
            return true
        }
        else{
            return false
        }
        
    }
    
    
    
   
    
    override func viewDidLoad() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    // *** BUTTONS ***//
    //---------------
    
    
    //@IBOutlet var buttonContinue: WKInterfaceButton!
    //@IBOutlet var buttonPause: WKInterfaceButton!
    
   // @IBAction func stopButtonPressed() {
        
        
    //}
    
  /*
    @IBAction func buttonPausePressed() {
        buttonPause.setHidden(true)
        buttonContinue.setHidden(false)
        
        [self.locationManager .stopUpdatingLocation()]
        
        
    }
    
    
    @IBAction func buttonContinuePressed() {
        
        buttonContinue.setHidden(true)
        buttonPause.setHidden(false)
        
        userLocationInfoEND = ["0","0","0","0"]
        userLocationInfoSTART = ["0","0","0","0"]
        
        [self.locationManager .startUpdatingLocation()]
        
    }
    
    */
    
    
    
    

}
