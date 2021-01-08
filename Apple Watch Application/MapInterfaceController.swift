//
//  MapInterfaceController.swift
//  Street Guardian WatchKit Extension
//
//  Created by Konstantinos Pytharoulios on 20/11/20.
//

import UIKit
import WatchKit
import Foundation
import CoreLocation
import MapKit
import CoreAudio
import AVFoundation

class MapInterfaceController: WKInterfaceController, CLLocationManagerDelegate{
    
    // These help us for the decibel counting
    var timer: DispatchSourceTimer?
    var audioRecorder: AVAudioRecorder!
    
    var location : CLLocation?
   
    var secondsOfNotMoving = 0
    
    @IBOutlet var map: WKInterfaceMap!
    
    var locationManager = CLLocationManager()
    
    var userLocationInfoSTART = [String]()
    var userLocationInfoEND = ["0","0","0","0"]
    
    override func awake(withContext context: Any?) {
       
        
        // Start tracking the location of the user
        // in order to find abnormal speed changes
        startTrackingLocation()

       
        // Start decibel counting again
        startRecordingAudio()
        
        // Shows moving point on map
        map.setShowsUserLocation(true)
    }
    
    /* THIS PART IS ABOUT USING GPS TO TRACK LOCATION AND SPEED */
    //================================================================
    //----------------------------------------------------------------------------------------------------
    // If a VERY sudden change in drivers speed is detected, the app considers it as a possible car crash
    // thus it moves on to Warning VC.
    
    func startTrackingLocation(){
        // Configure interface objects here.
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        //locationManager.allowsBackgroundLocationUpdates = true // this makes sure that the app is still updating user's location in the background
    }

    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
       
        let locationArray = locations as NSArray
        
        location = locationArray.lastObject as! CLLocation
        
        userLocationInfoSTART.removeAll(keepingCapacity: true)
        userLocationInfoSTART.append("\(location!.coordinate.latitude)")
        userLocationInfoSTART.append("\(location!.coordinate.longitude)")
        userLocationInfoSTART.append("\(location!.speed)")
        userLocationInfoSTART.append("\(location!.timestamp)")
        
        
        // IF we have a sudden speed change
        // <OR>
        // IF the car has not moved for over half an hour
        // SEND WARNING MESSAGES
        if isSuddenSpeedChange(speedStart: userLocationInfoEND[2], speedEnd: userLocationInfoSTART[2]) || isNotMovingForALong(speedStart: userLocationInfoEND[2], speedEnd: userLocationInfoSTART[2]){
            // True: The case that an abnormal changing of speed was detected
            
            // stop location detection
            [self.locationManager .stopUpdatingLocation()]
            
            //stop decibel counting
            finishRecording()
            
            let locationDict = ["latitude" : "\(location!.coordinate.latitude)", "longitude" : "\(location!.coordinate.longitude)", "altitude" : "\(location!.altitude)" ]
            
            pushController(withName: "warningInterfaceController", context: locationDict )
        }
        else{
           // FALSE: EVERYTHING SEEMS FINE WITH THE SPEED
        }
      
        
        print(userLocationInfoEND)
        print(userLocationInfoSTART)
        print("\n\n")
        
        // Speed before, becomes speed after.
        userLocationInfoEND = userLocationInfoSTART
        
        
        let coordinate = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        
        let region = MKCoordinateRegion(center: coordinate, span: span )
        
        map.setRegion(region)
        
    }
    
    

    
    // This is the function which checks the changing of speed.
    // Returns TRUE: When is has detected an abnormal changing in speed.
    // Returns FALSE: When everything seems ok.
    func isSuddenSpeedChange(speedStart:String, speedEnd:String) -> Bool{
        
        // division with / 1000.0 * 60.0 * 60.0 converts speed to km/h
        let doubleSpeedStart = Double(speedStart)! / 1000.0 * 60.0 * 60.0
        let doubleSpeedEnd = Double(speedEnd)! / 1000.0 * 60.0 * 60.0
        
        print(doubleSpeedEnd)
        
        // If the speed gets reduced by 20% or more, then we have a possible car crash
        if (doubleSpeedStart-doubleSpeedEnd) >= (doubleSpeedStart * 0.2){
            // We have a noticeable speed change
            
            //print("Start: \(doubleSpeedStart)")
           // print("Stop: \(doubleSpeedEnd) \n\n\n\n")
            return true
        }
        else{
            return false
        }
        
        
    }
    
    // This is a function which checks if the car is not moving for a
    // a long time which is something suspicious.
    func isNotMovingForALong(speedStart: String, speedEnd: String) -> Bool{
        
        // division with / 1000.0 * 60.0 * 60.0 converts speed to km/h
        let doubleSpeedStart = Double(speedStart)! / 1000.0 * 60.0 * 60.0
        let doubleSpeedEnd = Double(speedEnd)! / 1000.0 * 60.0 * 60.0
        
        if doubleSpeedStart == 0.0 && doubleSpeedEnd == 0.0{
            self.secondsOfNotMoving = self.secondsOfNotMoving + 1 // one more second of not moving
            
            if self.secondsOfNotMoving == 1800{
                // IF THE CAR HAS BEEN STOPPED FOR HALF AN HOUR...
                return true
            }
        }
        else{
            self.secondsOfNotMoving = 0
        }
        
        return false
    }
    
    
    //----------------------------------------------------------------------------------------------------
   
    
    /* THIS PART IS ABOUT DECIBEL COUNTING WHILE DRIVING*/
    //=====================================================
    //----------------------------------------------------------------------------------------------------
    // The device's microphone remains open while the app is running, recording all the sounds of the car.
    // If an abnormal audio volume (a really high one) the app considers it to be a car crash and thus
    // it moves on to Calling Emergency.
    // According to formal sources of information about car crashes: "The noise level of a car crash is often over 150 dB, which is very loud and very hard on hearing. And the noise level of airbags deploying is around 165 dB.
    // In our case we will use the barrier of 165dB to understand if we have a crash or not.
    //----------------------------------------------------------------------------------------------------
    
    /* STARTS AUDIO RECORDING*/
    func startRecordingAudio(){
        
        let url = directoryURL() //else {
            //print("Unable to find a init directoryURL")
            //return false
        
        let recordSettings = [
            AVSampleRateKey : NSNumber(value: Float(44100.0) as Float),
            AVFormatIDKey : NSNumber(value: Int32(kAudioFormatMPEG4AAC) as Int32),
            AVNumberOfChannelsKey : NSNumber(value: 1 as Int32),
            AVEncoderAudioQualityKey : NSNumber(value: Int32(AVAudioQuality.medium.rawValue) as Int32),
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            audioRecorder = try AVAudioRecorder(url: url!, settings: recordSettings)
            audioRecorder.prepareToRecord()
            audioRecorder.record()
            try audioSession.setActive(true)
            audioRecorder.isMeteringEnabled = true
            recordForever(audioRecorder: audioRecorder)
        } catch let err {
            print("Unable start recording", err)
        }
               
    }
    
    /* CREATES A URL TO STORE AUDIO*/
    func directoryURL() -> URL? {
        let fileManager = FileManager.default
        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = urls[0] as URL
        let soundURL = documentDirectory.appendingPathComponent("sound.m4a")
        return soundURL
    }
    
    /* OPTIONS LIKE INTEVAL TIME FOR RECORDING AUDIO*/
    func recordForever(audioRecorder: AVAudioRecorder) {
        let queue = DispatchQueue(label: "io.segment.decibel", attributes: .concurrent)
        timer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        timer?.scheduleRepeating(deadline: .now(), interval: .seconds(1), leeway: .milliseconds(100))
        timer?.setEventHandler { [weak self] in
            audioRecorder.updateMeters()

            if self!.soundBarrierExceeded(){
                // IF A CRASHING SOUND WAS DETECTED MOVE TO NEXT WARNING VC
                
                // Stop location detection
                [self!.locationManager .stopUpdatingLocation()]
                
                // Stop audio recording
                self!.finishRecording()
                
                let locationDict = ["latitude" : "\(self!.location!.coordinate.latitude)", "longitude" : "\(self!.location!.coordinate.longitude)", "altitude" : "\(self!.location!.altitude)" ]
                
                self!.pushController(withName: "warningInterfaceController", context: locationDict )
                
            }
                
        
        }
        timer?.resume()
    }
    
    /* CHECKS IF SOUND BARRIER IS ECSEEDED - IF WE HAVE A CRASH SOUND*/
    func soundBarrierExceeded() -> Bool{
        // NOTE: seems to be the approx correction to get real decibels
        let correction: Float = 100
        let average = audioRecorder.averagePower(forChannel: 0) + correction
        let peak = audioRecorder.peakPower(forChannel: 0) + correction
        //self?.recordDatapoint(average: average, peak: peak)
        print("PEAK: \(peak)\n\n\n")
        if peak >= 115{
            // IF SOUND BARRIER HAS BEEN EXCEEDED
            print("WARNING: Very loud noise was detected!!\n\n")
            return true
        }
        else{
            // IF EVERYTHING IS OK KEEP GOING
            return false
        }
    }
    
    /* THIS STOPS THE PROCEDURE OF AUDIO RECORDING AND CHECKING*/
    func finishRecording() {
        print("finishing recording\n\n\n")
        timer?.cancel()
        audioRecorder.stop()
        audioRecorder = nil
    }
    
    //----------------------------------------------------------------------------------------------------
   
    // *** BUTTONS ***//
    //--------------------------------------------------------------
    
    
    @IBOutlet var buttonContinue: WKInterfaceButton!
    @IBOutlet var buttonPause: WKInterfaceButton!
    
    
    @IBAction func buttonPausePressed() {
        buttonPause.setHidden(true)
        buttonContinue.setHidden(false)
        
        // hide map
        map.setHidden(true)
        
        //stop location detection
        [self.locationManager .stopUpdatingLocation()]
        
        //stop decibel counting
        finishRecording()
        
        
    }
    
    
    @IBAction func buttonContinuePressed() {
        
        buttonContinue.setHidden(true)
        buttonPause.setHidden(false)
        map.setHidden(false)
        
        userLocationInfoEND = ["0","0","0","0"]
        userLocationInfoSTART = ["0","0","0","0"]
        
        // Start location manager again
        [self.locationManager .startUpdatingLocation()]
        
        // Start decibel counting again
        startRecordingAudio()
        
    }
    
    
    
    
    
    

}
