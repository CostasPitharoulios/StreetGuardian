//
//  endOfRegistrationViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 13/11/20.
//

import UIKit
import Firebase
import FirebaseAuth


class endOfRegistrationViewController: UIViewController {
    
    
    
   
    @IBAction func buttonPressed(_ sender: Any) {
        
        // Get user's email from user defaults.
        let usersEmail: String = UserDefaults.standard.string(forKey: "email") ?? "nil"
        
        // Get user's password from user defaults.
        let usersPassword: String = UserDefaults.standard.string(forKey: "password") ?? "nil"
        
        
        
        // Create user AUTH in the database.
        Auth.auth().createUser(withEmail: usersEmail, password: usersPassword) { (result, err) in
            
            if err != nil{
                // There was an error creating the user
                print("Error creating user.\n")
            }
            else{
                // User was created succesfully.
                print("User was created.\n")
                
                
                let db = Firestore.firestore()
                
                let usersName: String =  UserDefaults.standard.string(forKey: "name") ?? "nil"
                let usersSurname: String = UserDefaults.standard.string(forKey: "surname") ?? "nil"
                let usersContactName: String = UserDefaults.standard.string(forKey: "contactName") ?? "nil"
                let usersContactEmail: String = UserDefaults.standard.string(forKey: "contactEmail") ?? "nil"
                
                
                
                // Saving user's info in firestore
                // !!! In firestore there is a collection "users" which contails all users info.
                // This collection has documents. Each document contains the info of a single user.
                // The id of each document is the same as users uid in order to have fast access to their info.
                db.collection("users").document("\(result!.user.uid)").setData(["firstname" : usersName, "lastname": usersSurname, "emergencyName": usersContactName, "emergencyEmail": usersContactEmail, "uid": result!.user.uid]) { (error) in
                //db.collection("users").addDocument(data: ["firstname" : usersName, "lastname": usersSurname, "emergencyName": usersContactName, "emergencyEmail": usersContactEmail, "uid": result!.user.uid]) { (error) in
                    
                    if error != nil{
                        // Show error message.
                        print("Error at saving user's details in firebase./n")
                    }
                    
                    
                }
                
                // Move to Home
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "tempStart") as! SWRevealViewController
                nextViewController.modalPresentationStyle = .fullScreen // this is to make it full screen and not just a pop up
                self.navigationController!.present(nextViewController, animated: true, completion: nil)
            }
          
        }
      
  
        
        
       
      
    }
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      

        // Do any additional setup after loading the view.
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
