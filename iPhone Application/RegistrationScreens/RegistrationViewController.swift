//
//  RegistrationViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 13/11/20.
//

import UIKit
import Foundation
import Firebase

class RegistrationViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var surnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    @IBOutlet var continueButton: UIButton!
    
    
    @IBOutlet var emailUsedLabel: UILabel!
    
    
    @IBOutlet var nameErrorLabel: UILabel!
    @IBOutlet var surnameErrorLabel: UILabel!
    @IBOutlet var emailErrorLabel: UILabel!
    
    @IBAction func haveAccountButtonpPressed(_ sender: Any){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "logsNavigationController") as!UINavigationController
        nextViewController.modalPresentationStyle = .fullScreen // this is to make it full screen and not just a pop up
        self.navigationController!.present(nextViewController, animated: true, completion: nil)
        
       
        
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        
        
        // Store User's Name in UserDefaults
        if (nameTextField.text?.count )! > 0 {
            let defaults = UserDefaults.standard.setValue(nameTextField.text!, forKey: "name")
            nameErrorLabel.isHidden = true
           }
        else{
            nameErrorLabel.isHidden = false
        }
       
        // Store User's Surname in UserDefaults
        if (surnameTextField.text?.count )! > 0 {
            let defaults = UserDefaults.standard.setValue(surnameTextField.text!, forKey: "surname")
            surnameErrorLabel.isHidden = true
           }
        else{
            surnameErrorLabel.isHidden = false
        }
        
        
         // Store User's Email in UserDefaults
        if isValidEmail(email: emailTextField.text!) {
             let defaults = UserDefaults.standard.setValue(emailTextField.text!, forKey: "email")
             emailErrorLabel.isHidden = true
            }
         else{
             emailErrorLabel.isHidden = false
         }
        
       
          
        // !!! Move to the next page of navigation Controller.
        if (nameTextField.text?.count )! > 0 && (surnameTextField.text?.count )! > 0 && isValidEmail(email: emailTextField.text!){
            
            // Check if the email given already exists.
            // If email is new, move to next VC
            checkEmailAvailability(email: emailTextField.text!)
            
            
        }
        
        
       
        
        
    }
    
    func checkEmailAvailability(email:String?) {
        
        Auth.auth().fetchSignInMethods(forEmail: emailTextField.text!) { signInMethods, error in
           
            var available : Bool = false
            if (error != nil){
                 // Email does not exist
                print("Error in registration while checking if email exists")
                available = false
            }
            else{
                if signInMethods == nil{
                    // EMAILS DOES NOT EXIST. YOU CAN USE IT.
                    print("email is new")
                    available = true
                }
                else{
                    // EMAIL DO EXISTS
                    print("email exists")
                    self.emailUsedLabel.isHidden = false
                    available = false
                }
                
                print("PROVIDERS")
                print(signInMethods)
                print(available)
                print("\n\n\n\n\n")
            }
            
            self.moveToNextVC(availability: available)
        
        }
      
    }
    
    func moveToNextVC(availability: Bool){
        print("The availabitilt is ")
        print(availability)
        print("\n\n\n\n")
        
        if availability == true{
            let nextVC = (self.storyboard?.instantiateViewController(withIdentifier: "passwordVC")) as! PasswordViewController
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to Personal Information")
        
        // Sign button is disabled
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        // Check when textfields are filled to enable Sign in button
        nameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        surnameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // This hides navigation bar at the top of the view controller.
        self.navigationController?.navigationBar.isHidden = true;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if Core.shared.isNewUser(){
            // show onboarding
            
            let vc = storyboard?.instantiateViewController(identifier: "myWelcome") as! MyWelcomeViewController
            present(vc, animated: true)
            
        }
        
    }
    
    // Email validator. It verifies:
    // 1. There’s some text before the @
    // 2. There’s some text after the @
    // 3. There’s at least 2 alpha characters after a .
    
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    // Detects it when there is a change in text fields
    // enables or disables button respectively.
    @objc func textFieldDidChange(textField: UITextField) {
    
        emailUsedLabel.isHidden = true
        
        if  !nameTextField.text!.isEmpty && !surnameTextField.text!.isEmpty && !emailTextField.text!.isEmpty{
            
        
            // EMAIL AND EVERYTHING IS FINE. GO AHEAD AND ENABLE BUTTON
                 
            continueButton.isEnabled = true
            continueButton.alpha = 1.0
            
        }
        else{
            
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
            
            
        }
    
    }
    

}

class Core{
    
    static let shared = Core()
    
    func isNewUser() -> Bool{
        return !UserDefaults.standard.bool(forKey: "isNewUser")
    }
    
    func setIsNotNewUser() {
        UserDefaults.standard.setValue(true, forKey: "isNewUser")
    }
    
}




