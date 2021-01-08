//
//  CallingEmergencyViewController.swift
//  Street Guardian
//
//  Created by Konstantinos Pytharoulios on 30/11/20.
//

import UIKit
import Firebase

class CallingEmergencyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Hide navigation bar
        self.navigationController!.navigationBar.isHidden = true;
        
        // Calls the function which saves location of emergency to firebase
        storeLocationToDatabase()
        
    }
    
    
    func storeLocationToDatabase(){
        
        let db = Firestore.firestore()
        
        // Get latitude, longitude, altitude from User Defaults
        let latitude : String = UserDefaults.standard.string(forKey: "latitudeEmergency") ?? "nil"
        let longitude : String = UserDefaults.standard.string(forKey: "longitudeEmergency") ?? "nil"
        let altitude: String = UserDefaults.standard.string(forKey: "altitudeEmergency") ?? "nil"
        
        // get timestamp
        let timeStampString : String = generateCurrentTimeStamp()
        
        //get user ID
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        // Get user's info from data base
        
       /* var emergencyEmail = String()
        var emergencyName = String()
        var userFirstname = String()
        var userLastname =  String()*/
        
        let documentUsersRef = db.collection("users").document("\(userID)")
        documentUsersRef.getDocument(completion: { document, error in
            if let err = error {
                print(err.localizedDescription)
                return
            }

            print( document!.data() ) //for testing to see if we are getting the fields

            //how to read a single field, like file within fl_files
            let emergencyEmail = document!.get("emergencyEmail") as! String
            let emergencyName = document!.get("emergencyName") as! String
            let userFirstname = document!.get("firstname") as! String
            let userLastname = document!.get("lastname") as! String
            
            
            // Store Emergency Location to Firebase
            //db.collection("EmergencyLocations").document("newLoc").setData([
            db.collection("EmergencyLocations").addDocument(data: [
                "latitude" : latitude,
                "longitude" : longitude,
                "altitude" : altitude,
                "timeStamp" : timeStampString,
                "userid" : userID,
                "emergencyEmail" : emergencyEmail,
                "emergencyName" : emergencyName,
                "userFirstname" : userFirstname,
                "userLastname" : userLastname
                
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
         
        })
        

        
        
        
       
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func stopCallingButtonPressed(_ sender: Any) {
        
        performSegue(withIdentifier: "unwindFromCallingToWakeUp", sender: self)
    }
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
}
