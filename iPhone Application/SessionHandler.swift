import Foundation
import WatchConnectivity
import Firebase

class SessionHandler : NSObject, WCSessionDelegate {
    
    // 1: Singleton
    static let shared = SessionHandler()
    
    // 2: Property to manage session
    private var session = WCSession.default
    
    override init() {
        super.init()
        
        // 3: Start and avtivate session if it's supported
        if isSuported() {
            session.delegate = self
            session.activate()
        }
        
        print("isPaired?: \(session.isPaired), isWatchAppInstalled?: \(session.isWatchAppInstalled)")
    }
    
    func isSuported() -> Bool {
        return WCSession.isSupported()
    }
    
    
    // MARK: - WCSessionDelegate
    
    // 4: Required protocols
    
    // a
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        print("IPHONE:   activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
    }

    // b
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("sessionDidBecomeInactive: \(session)")
    }

    // c
    func sessionDidDeactivate(_ session: WCSession) {
        print("sessionDidDeactivate: \(session)")
        // Reactivate session
        /**
         * This is to re-activate the session on the phone when the user has switched from one
         * paired watch to second paired one. Calling it like this assumes that you have no other
         * threads/part of your code that needs to be given time before the switch occurs.
         */
        self.session.activate()
    }
    
    /// Observer to receive messages from watch and we be able to response it
    ///
    /// - Parameters:
    ///   - session: session
    ///   - message: message received
    ///   - replyHandler: response handler
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        //if message["request"] as? String == "version" {
            //replyHandler(["version" : "\(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") ?? "No version")"])
            print("EXCELLENT!!! I AM THE IPHONE AND I HAVE RECEIVED THE MESSAGE!\n\n\n")
            
            // Get user's email from user defaults.
            let usersEmail: String = UserDefaults.standard.string(forKey: "email") ?? "nil"
            
            // Get user's password from user defaults.
            let usersPassword: String = UserDefaults.standard.string(forKey: "password") ?? "nil"
            
            // Programmatically signing in the user
            Auth.auth().signIn(withEmail: usersEmail, password: usersPassword) { (result, error) in
                
                if error != nil{
                    // Couldn't sign in
                    print("Couldn't sign in!")
                }
                else{
                    // SIGNED IN
                    print("signed in")
                    let db = Firestore.firestore()
                    
                    // get user's id
                    guard let userID = Auth.auth().currentUser?.uid else { return }
                    
                    // get timestamp
                    let timeStampString : String = self.generateCurrentTimeStamp()
                    
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
                            "latitude" : message["latitude"] as! String,
                            "longitude" : message["longitude"] as! String,
                            "altitude" : message["altitude"] as! String,
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
                    
                    print("uSEid: \(userID)")
                    
    
                    
                }
            }
            
            
            
       /* }
        else{
            print("Phone has received a different string as message\n\n\n")
        }
 */
    }
    
    func generateCurrentTimeStamp () -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy hh:mm:ss"
        return (formatter.string(from: Date()) as NSString) as String
    }
    
}
