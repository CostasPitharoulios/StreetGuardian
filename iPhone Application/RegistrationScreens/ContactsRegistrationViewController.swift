//
//  ContactsRegistrationViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 13/11/20.
//

import UIKit

class ContactsRegistrationViewController: UIViewController {

    @IBOutlet var contactNameTextField: UITextField!
    @IBOutlet var contactEmailTextField: UITextField!
    
    @IBOutlet var contactNameErrorLabel: UILabel!
    @IBOutlet var contactEmailErrorLabel: UILabel!
    
    @IBOutlet var continueButton: UIButton!
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        // Store User's emergency contact in UserDefaults
        if (contactNameTextField.text?.count )! > 0 {
            let defaults = UserDefaults.standard.setValue(contactNameTextField.text!, forKey: "contactName")
            contactNameErrorLabel.isHidden = true
           }
        else{
            contactNameErrorLabel.isHidden = false
        }
       
        // Store User's emergency Email in UserDefaults
        if isValidEmail(email: contactEmailTextField.text) {
            let defaults = UserDefaults.standard.setValue(contactEmailTextField.text!, forKey: "contactEmail")
            contactEmailErrorLabel.isHidden = true
           }
        else{
            contactEmailErrorLabel.isHidden = false
        }
        
        
        // !!! Move to the next page of navigation Controller.
        if (contactNameTextField.text?.count )! > 0 && isValidEmail(email: contactEmailTextField.text) {
            let endOfRegistrationVC = (self.storyboard?.instantiateViewController(withIdentifier: "endOfRegistrationVC")) as! endOfRegistrationViewController
            self.navigationController?.pushViewController(endOfRegistrationVC, animated: true)
        }
        
        
        
    }
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        //let myString = UserDefaults.standard.string(forKey: "name")
      
        // This unhides navigation bar at the top of the view controller.
        
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to your Emergency Contacts")
        
        self.navigationController?.navigationBar.isHidden = false;
        
        // Sign button is disabled
        continueButton.isEnabled = false
        continueButton.alpha = 0.5
        
        // Check when textfields are filled to enable Sign in button
        contactNameTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        contactEmailTextField.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)

        // Do any additional setup after loading the view.
    }
    
    
    // Detects it when there is a change in text fields
    // enables or disables button respectively.
    @objc func textFieldDidChange(textField: UITextField) {
    
        
        if  !contactNameTextField.text!.isEmpty && !contactEmailTextField.text!.isEmpty{
            // EMAIL AND EVERYTHING IS FINE. GO AHEAD AND ENABLE BUTTON
                 
            continueButton.isEnabled = true
            continueButton.alpha = 1.0
            
        }
        else{
            
            continueButton.isEnabled = false
            continueButton.alpha = 0.5
            
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


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
