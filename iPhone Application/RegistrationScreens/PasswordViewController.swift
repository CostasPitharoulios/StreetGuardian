//
//  PasswordViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 27/11/20.
//

import UIKit

class PasswordViewController: UIViewController {


    @IBOutlet var passwordText: UITextField!
    @IBOutlet var repeatedPasswordText: UITextField!
    
    
    @IBOutlet var passwordErrorLabel: UILabel!
    
    @IBOutlet var continueButton: UIButton!
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
       
        
        if (passwordText.text?.count )! > 0 && (repeatedPasswordText.text?.count)! > 0 && ((passwordText.text?.elementsEqual(repeatedPasswordText.text!))! == true){
            
            if isValidPassword(testStr: passwordText.text){ // if passwords are the same and valid
                passwordErrorLabel.isHidden = true
            }
            else{ // if passwords are the same but not valid
                passwordErrorLabel.text = "The password must be at least 8 characters long including at least one upper case letter, one lower case letter and one numerical character."
                passwordErrorLabel.isHidden = false
            }
            
           }
        else{
            
            passwordErrorLabel.text = "The passwords given are not the same."
            passwordErrorLabel.isHidden = false
        }
        
        
        // !!! Move to the next page of navigation Controller.
        if (passwordText.text?.count )! > 0 && (repeatedPasswordText.text?.count )! > 0 && ((passwordText.text?.elementsEqual(repeatedPasswordText.text!))! == true) && isValidPassword(testStr: passwordText.text){
            
            // Store password to user defaults.
           
            let defaults = UserDefaults.standard.setValue(passwordText.text!, forKey: "password")
           
            // Move to next View Controller
            let nextVC = (self.storyboard?.instantiateViewController(withIdentifier: "contactsRegistrationVC")) as! ContactsRegistrationViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sign button is disabled
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        // Check when textfields are filled to enable Sign in button
        passwordText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        repeatedPasswordText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        //navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Password Settings")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // This hides navigation bar at the top of the view controller.
        self.navigationController?.navigationBar.isHidden = false;
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Password Settings")

    }
    
    // Password Validator. It checks for:
    // 1. There’s at least one uppercase letter
    // 2. There’s at least one lowercase letter
    // 3. There’s at least one numeric digit
    // 4. The text is at least 8 characters long
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    
    // Detects it when there is a change in text fields
    // enables or disables button respectively.
    @objc func textFieldDidChange(textField: UITextField) {
    
        
        if  !passwordText.text!.isEmpty && !repeatedPasswordText.text!.isEmpty{
            // EMAIL AND EVERYTHING IS FINE. GO AHEAD AND ENABLE BUTTON
                 
            continueButton.isEnabled = true
            continueButton.alpha = 1.0
            
        }
        else{
            
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
            
        }
    
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
