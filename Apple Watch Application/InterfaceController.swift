//
//  InterfaceController.swift
//  Street Guardian WatchKit Extension
//
//  Created by Konstantinos Pytharoulios on 10/11/20.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {
   
    @IBAction func jumpToMapInterfaceButton() {
        
        pushController(withName: "mapInterfaceController", context: "fromInterface1")
        
    }
    
   
    @IBOutlet var messageLabel: WKInterfaceLabel!
    

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        
       
        
        let usersName = UserDefaults.standard.string(forKey: "usersName")
        self.messageLabel.setText(usersName)
          
    }
    
   
    
    

}
