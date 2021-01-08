//
//  PersonalDetailsViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 15/11/20.
//

import UIKit
import Firebase

class PersonalDetailsViewController: UIViewController {

    
    @IBOutlet var menuButton: UIBarButtonItem!
    
    @IBOutlet var nameTextfield: UITextField!
    @IBOutlet var surnameTextfield: UITextField!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var saveButton: UIButton!
    
    @IBOutlet var emailErrorLabel: UILabel!
    @IBOutlet var nameErrorLabel: UILabel!
    @IBOutlet var surnameErrorLabel: UILabel!
    
    @IBOutlet var savedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        // Do any additional setup after loading the view.
        */
        
        savedLabel.isHidden = true
        
        // Navigation Bar Color
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 255.0/255.0, green: 209.0/255.0, blue: 70.0/255.0, alpha: 1.0)
        
        // Make buck button white
        navigationController?.navigationBar.tintColor = .white
        // Set the text of the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back to your personal info")
        
        //Menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        // These help us detect a change in the text fields
        nameTextfield.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        surnameTextfield.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        emailTextfield.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
        
        
        // Getting all the info from the database
        getInfoFromDatabse()
        
        
        saveButton.isEnabled = false
        saveButton.alpha = 0.5
            
                
    }
    
    
    func getInfoFromDatabse(){
        //get user ID
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let userEmail = Auth.auth().currentUser?.email else {return}
        
        let db = Firestore.firestore()
        
        let documentUsersRef = db.collection("users").document("\(userID)")
        documentUsersRef.getDocument(completion: { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }

            print("Document data")
            print( document!.data() ) //for testing to see if we are getting the fields
            print("\n\n\n\n")
            
            //how to read a single field, like file within fl_files
            let userFirstname = document!.get("firstname") as! String
            let userLastname = document!.get("lastname") as! String
            
            self.nameTextfield.text = userFirstname
            self.surnameTextfield.text = userLastname
            self.emailTextfield.text = userEmail
        })
        
        

    }
    
    
    // Detects it when there is a change in text fields
    // enables or disables button respectively.
    @objc func textFieldDidChange(textField: UITextField) {
        
        savedLabel.isHidden = true
        
        nameErrorLabel.isHidden = true
        surnameErrorLabel.isHidden = true
        emailErrorLabel.isHidden = true
        
        
        if  !nameTextfield.text!.isEmpty && !surnameTextfield.text!.isEmpty && isValidEmail(email: emailTextfield.text!) {
            
            // EMAIL AND EVERYTHING IS FINE. GO AHEAD AND ENABLE BUTTON
                 
            saveButton.isEnabled = true
            saveButton.alpha = 1.0
            
        }
        else{
            
            if nameTextfield.text!.isEmpty{
                nameErrorLabel.isHidden = false
            }
            
            if surnameTextfield.text!.isEmpty{
                surnameErrorLabel.isHidden = false
            }
            
            if  !isValidEmail(email: emailTextfield.text!){
                emailErrorLabel.isHidden = false
            }
            
            saveButton.isEnabled = false
            saveButton.alpha = 0.5
            
            
        }
    
    }
    
    func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }

    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        let usersName = nameTextfield.text!
        let usersSurname = surnameTextfield.text!
        
        let db = Firestore.firestore()
        
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        
        // update users name and surname
        db.collection("users").document("\(userID)").updateData(["firstname" : usersName, "lastname": usersSurname ]) { (error) in
        //db.collection("users").addDocument(data: ["firstname" : usersName, "lastname": usersSurname, "emergencyName": usersContactName, "emergencyEmail": usersContactEmail, "uid": result!.user.uid]) { (error) in
            
            if error != nil{
                // Show error message.
                print("Error at saving user's details in firebase./n")
            }else{
                // Save completed
                self.saveButton.isEnabled = false
                self.saveButton.alpha = 0.5
                
                // Show successful message
                self.savedLabel.isHidden = false
                
            }
        }
        
        //update email
        let user = Auth.auth().currentUser
        user?.updateEmail(to: "\(emailTextfield.text!)") { [self] error in
            if error != nil {
                print("Email was not updated.")
            } else{
                UserDefaults.standard.setValue(emailTextfield.text!, forKey: "email")
                print("Email updated.")
            }
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
