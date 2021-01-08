//
//  ForgotPasswordViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 5/12/20.
//

import UIKit
import Firebase

class ForgotPasswordViewController: UIViewController {

    @IBOutlet var emailTextField: UITextField!
    
    
    @IBOutlet var wrongEmailLabel: UILabel!
    @IBOutlet var successfulEmailSentLabel: UILabel!
    @IBOutlet var sendResetEmailButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController!.navigationBar.isHidden = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Navigation Bar Color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255.0/255.0, green: 209.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Send button is disabled
        sendResetEmailButton.isEnabled = false
        sendResetEmailButton.alpha = 0.5
        
        // Check when textfields are filled to enable Sign in button
        emailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sendResetEmailButtonPressed(_ sender: Any) {
        
        
        if isValidEmail(email: emailTextField.text){
        // IF THE EMAIL IS WELL SPELLED
            
            Auth.auth().sendPasswordReset(withEmail: "\(emailTextField.text!)") { error in
                if error != nil {
                    print("Coulnd't send reset email.")
                    self.wrongEmailLabel.isHidden = false
                } else{
                    print("Reset email has been sent.")
                    self.successfulEmailSentLabel.isHidden = false
                }
            }
            
            
        }
        else{
            wrongEmailLabel.isHidden = false
        }
        
        // Send button is disabled
        sendResetEmailButton.isEnabled = false
        sendResetEmailButton.alpha = 0.5
        
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
    
        wrongEmailLabel.isHidden = true
        successfulEmailSentLabel.isHidden = true
        
        if  isValidEmail(email: emailTextField.text!){
            // EMAIL AND EVERYTHING IS FINE. GO AHEAD AND ENABLE BUTTON
                 
            sendResetEmailButton.isEnabled = true
            sendResetEmailButton.alpha = 1.0
            
        }
        else{
            
            sendResetEmailButton.isEnabled = false
            sendResetEmailButton.alpha = 0.5
            
            
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
