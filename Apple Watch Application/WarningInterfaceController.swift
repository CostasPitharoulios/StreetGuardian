//
//  WarningInterfaceController.swift
//  Street Guardian WatchKit Extension
//
//  Created by Konstantinos Pytharoulios on 22/11/20.
//

import UIKit
import WatchKit



class WarningInterfaceController: WKInterfaceController {
    

    
    var locationData : [String : Any] = [:]
    
    var timer: Timer?
    override func awake(withContext context: Any?) {
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        locationData = context as! [String : Any]
        //let latitude : String? = context["latitude"]
        //print("Latitude: \(String(describing: latitude))")
        
    }
    
    @IBOutlet var countdownLabel: WKInterfaceLabel!
    var counter = 30
    
    @objc func updateCounter() {
        //example functionality
        if counter >= 0 {
            // IF COUNTER STILL DECENDING...
            
        
            
            countdownLabel.setText("\(counter) s for sos message.")
            //print("\(counter) seconds to the end of the world")
            counter -= 1
        }
        else{
            timer!.invalidate() // We stop the timer. In any other case it will loop here endlessly.
            pushController(withName: "callingEmergencyInterfaceController", context: locationData) // Going to Interface Controller of Emergency Numbers calling.
        }
    }
    
    @IBAction func buttonBackPressed() {
        
        timer!.invalidate() // We stop the the timer or it will keep counting while we are back in maps
        pushController(withName: "mapInterfaceController", context: "fromWarningInterface") // Going back to map
    }

    @IBAction func buttonHelpPressed() {
        timer!.invalidate() // We stop the the timer or it will keep counting while we are back in maps
        pushController(withName: "callingEmergencyInterfaceController", context: locationData) // Going back to map
    }
}
