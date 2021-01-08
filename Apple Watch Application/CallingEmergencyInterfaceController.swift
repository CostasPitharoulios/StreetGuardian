//
//  CallingEmergencyInterfaceController.swift
//  Street Guardian WatchKit Extension
//
//  Created by Konstantinos Pytharoulios on 23/11/20.
//

import UIKit
import WatchKit
import Foundation
import WatchConnectivity


class CallingEmergencyInterfaceController: WKInterfaceController, WCSessionDelegate {
    
    var locationData : [String : Any] = [:]
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
        
        // Sends message with details to phone
        /**
        *  The iOS device is within range, so communication can occur and the WatchKit extension is running in the
        *  foreground, or is running with a high priority in the background (for example, during a workout session
        *  or when a complication is loading its initial timeline data).
        */
        if isReachable() {
            /*session.sendMessage(["request" : "version"], replyHandler: nil, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })*/
            session.sendMessage(locationData, replyHandler: { (response) in
                print("Reply: \(response) \n\n")
            }, errorHandler: { (error) in
                print("Error sending message: %@", error)
            })
            print("Iphone is reachable!")
        } else {
            print("iPhone is not reachable!!")
        }
        
    }
    
    
    // 1: Session property
    private var session = WCSession.default
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
            
        locationData = context as! [String : Any]
        
        print(locationData)
        // Configure interface objects here.
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
            
        // 2: Initialization of session and set as delegate this InterfaceController if it's supported
        if isSuported() {
            session.delegate = self
            session.activate()
            print("isSupported\n\n\n\n")
        }
        else{
            print("NOTSUPPORTED\n\n\n")
        }
        
        
       
            
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    private func isSuported() -> Bool {
        return WCSession.isSupported()
    }
        
    private func isReachable() -> Bool {
        return session.isReachable
    }
    
   

}

extension InterfaceController: WCSessionDelegate {
    
    // 4: Required stub for delegating session
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("WATCH:   activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }
    
}
