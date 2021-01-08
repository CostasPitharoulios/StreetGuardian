//
//  OptionsViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 13/12/20.
//

import UIKit

class OptionsViewController: UIViewController {

    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var switch1: UISwitch!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255.0/255.0, green: 209.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // MENU
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        switch1.isEnabled = true
      
        // Do any additional setup after loading the view.
    }
    
    
}
