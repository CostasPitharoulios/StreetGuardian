//
//  WarningViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 30/11/20.
//

import UIKit
import AVFoundation
import AudioToolbox



class WarningViewController: UIViewController {

    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Hide navigation bar
        self.navigationController!.navigationBar.isHidden = true;
        
        // Schedule Timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
       
        
        // Do any additional setup after loading the view.
    }
    
    // Countdown for 30s before sending emergency messages
    @IBOutlet var countdownLabel: UILabel!
    
   
    var counter = 30
    
    @objc func updateCounter() {
        //example functionality
        if counter >= 0 {
            // IF COUNTER STILL DECENDING...
            
            // Play alarming sound
            AudioServicesPlaySystemSound(1304)
            // Make vibration alert
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
            
            countdownLabel.text = ("\(counter) s for sos message.")
            //print("\(counter) seconds to the end of the world")
            counter -= 1
            
        }
        else{
            // IF THE COUNTER HAS JUST REACHED 0
            
            timer!.invalidate() // We stop the timer. In any other case it will loop here endlessly.
            
            // Move to Calling Emergency VC
            performSegue(withIdentifier: "fromWarningToCalling", sender: self)
            
            //pushController(withName: "callingEmergencyInterfaceController", context: "fromWarningInterface") // Going to Interface Controller of Emergency Numbers calling.
        }
    }
    
    @IBAction func buttonSafePressed() {
        // GO BACK TO MAP
        
        // We stop the the timer or it will keep counting while we are back in maps
        timer!.invalidate()
        
        // Move to PREVIOUS VC - Map VC
       // _ = navigationController!.popViewController(animated: true)
        performSegue(withIdentifier: "unwindFromWarningToMap", sender: self)
       
        
        //pushController(withName: "mapInterfaceController", context: "fromWarningInterface") // Going back to map
    }

    
    @IBAction func buttonHelpPressed(_ sender: Any) {
       
        // We stop the the timer or it will keep counting while we are back in maps
        timer!.invalidate()
        
        // Move to Calling Emergency VC
        performSegue(withIdentifier: "fromWarningToCalling", sender: self)
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
