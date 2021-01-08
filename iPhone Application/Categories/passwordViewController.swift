//
//  passwordViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 4/12/20.
//

import UIKit
import Firebase

class passwordViewController: UIViewController {
    
    @IBOutlet var passwordText: UITextField!
    @IBOutlet var repeatedPasswordText: UITextField!
    
    
    @IBOutlet var passwordErrorLabel: UILabel!
    @IBOutlet var passwordChangedLabel: UILabel!
    
    @IBOutlet var changePasswordButton: UIButton!

    
    @IBAction func changePasswordButtonPressed(_ sender: Any) {
        
       
        
        if (passwordText.text?.count )! > 0 && (repeatedPasswordText.text?.count)! > 0 && ((passwordText.text?.elementsEqual(repeatedPasswordText.text!))! == true){
            
            if isValidPassword(testStr: passwordText.text){ // if passwords are the same and valid
                passwordErrorLabel.isHidden = true
                
                //update email
                let user = Auth.auth().currentUser
                user?.updatePassword(to: "\(passwordText.text!)") { [self] error in
                    if error != nil {
                        print("Password was not updated.")
                    } else{
                        print("Password is updated.")
                        UserDefaults.standard.setValue(passwordText.text!, forKey: "password")
                        self.passwordChangedLabel.isHidden = false
                        
                    }
                }
                
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
         
        self.changePasswordButton.isEnabled = false
        self.changePasswordButton.alpha = 0.5
        
    }
    
    func isValidPassword(testStr:String?) -> Bool {
        guard testStr != nil else { return false }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: testStr)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navigation Bar Color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255.0/255.0, green: 209.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Change password button is disabled
        changePasswordButton.isEnabled = false
        changePasswordButton.alpha = 0.5
        
        // These help us detect a change in the text fields
        passwordText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        repeatedPasswordText.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
       

        // Do any additional setup after loading the view.
    }
    
    @objc func textFieldDidChange(textField: UITextField) {
        
        self.passwordChangedLabel.isHidden = true
        if  !passwordText.text!.isEmpty && !repeatedPasswordText.text!.isEmpty{
            // EMAIL AND EVERYTHING IS FINE. GO AHEAD AND ENABLE BUTTON
                 
            changePasswordButton.isEnabled = true
            changePasswordButton.alpha = 1.0
            
        }
        else{
            
            changePasswordButton.isEnabled = false
            changePasswordButton.alpha = 0.5
            
        }
    
    }
    
    @IBAction func goBackToGuardButtonPressed(_ sender: Any) {
        
              let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
              let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tempStart") as! SWRevealViewController
              nextViewController.modalPresentationStyle = .fullScreen // this is to make it full screen and not just a pop up
              self.navigationController!.present(nextViewController, animated: true, completion: nil)
        
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
