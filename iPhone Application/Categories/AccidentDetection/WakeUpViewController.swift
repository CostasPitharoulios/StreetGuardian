//
//  WakeUpViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 30/11/20.
//

import UIKit

class WakeUpViewController: UIViewController {
    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var logo: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
        // Navigation Bar Color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255.0/255.0, green: 209.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Unhide naviagation bar
        self.navigationController!.navigationBar.isHidden = false;
        
        // MENU
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
       

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func wakeUpButtonPressed(_ sender: Any) {
        // Move to Map View Controller
       // let nextVC = (self.storyboard?.instantiateViewController(withIdentifier: "mapVC")) as! MapViewController
       // self.navigationController?.pushViewController(nextVC, animated: true)
        performSegue(withIdentifier: "fromWakeUpToMap", sender: self)
        
    }
    
    
    @IBAction func unwindFromMapToWakeUp( _ seg: UIStoryboardSegue) {
        
        // Unhide naviagation bar
        self.navigationController!.navigationBar.isHidden = false;
        
        
    }
    
    @IBAction func unwindFromCallingToWakeUp( _ seg: UIStoryboardSegue) {
        
        // Unhide naviagation bar
        self.navigationController!.navigationBar.isHidden = false;
        
        
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
