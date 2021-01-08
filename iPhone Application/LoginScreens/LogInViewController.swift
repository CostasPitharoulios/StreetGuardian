//
//  LogInViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 29/11/20.
//

import UIKit
import Firebase
import FirebaseAuth

class LogInViewController: UIViewController {
   
    @IBOutlet var signInButton: UIButton!
    @IBOutlet var signUpButton: UIButton!
    
    
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    
    @IBOutlet var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //log out to be sure
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        errorLabel.isHidden = true
        
        // adds black borderline to button Sign Up
        signUpButton.layer.borderWidth = 1
        //signUpButton.layer.borderColor =
        // Do any additional setup after loading the view.
        
        
        // Sign button is disabled
        signInButton.isEnabled = false
        signInButton.alpha = 0.5
        
        // Check when textfields are filled to enable Sign in button
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        // Make buck button white
        navigationController?.navigationBar.tintColor = .white
        // Set the text of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to login screen")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = true;
    }
   
    
    @IBAction func signInButtonPressed(_ sender: Any) {
        
        // Create cleaned versions of the text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        // Signing in the user
        
        print(email)
        print(password)
        print("\n\n\n\n")
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            
            if error != nil{
                // Couldn't sign in
                print("Couldn't sign in!")
                self.errorLabel.isHidden = false
            }
            else{
                self.errorLabel.isHidden = true
               
                // Move to Welcome page
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tempStart") as! SWRevealViewController
                nextViewController.modalPresentationStyle = .fullScreen // this is to make it full screen and not just a pop up
                self.navigationController!.present(nextViewController, animated: true, completion: nil)
                
            }
        }
        
    }
    
    
    @IBAction func signUpButtonPressed(_ sender: Any) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "registrationNavigationController") as!UINavigationController
        nextViewController.modalPresentationStyle = .fullScreen // this is to make it full screen and not just a pop up
        self.navigationController!.present(nextViewController, animated: true, completion: nil)
        
        
    }
    
    
    // Detects it when there is a change in text fields
    // enables or disables button respectively.
    @objc func textFieldDidChange(textField: UITextField) {
                
        
        if  !emailTextField.text!.isEmpty && !passwordTextField.text!.isEmpty{
            // EMAIL AND PASSWORD ARE FINE. GO AHEAD AND ENABLE BUTTON
                 
            signInButton.isEnabled = true
            signInButton.alpha = 1.0
            
        }
        else{
            
            signInButton.isEnabled = false
            signInButton.alpha = 0.5
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
