//
//  ViewController.swift
//  ParticleIOSStarter
//
//  Created by Parrot on 2019-06-29.
//  Copyright © 2019 Parrot. All rights reserved.

import UIKit
import Particle_SDK

class ViewController: UIViewController {

    // MARK: User variables
    let USERNAME = "kbkakhil459@gmail.com"
    let PASSWORD = "Kennyakhil27"
    
    // MARK: Device
    // Jenelle's device
    //let DEVICE_ID = "36001b001047363333343437"
    // Antonio's device
    let DEVICE_ID = "3b0021000247363333343435"
    var myPhoton : ParticleDevice?

    // MARK: Other variables
    var gameScore:Int = 0

    
    // MARK: Outlets
    
    @IBOutlet weak var shapeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 1. Initialize the SDK
        ParticleCloud.init()
 
        // 2. Login to your account
        ParticleCloud.sharedInstance().login(withUser: self.USERNAME, password: self.PASSWORD) { (error:Error?) -> Void in
            if (error != nil) {
                // Something went wrong!
                print("Wrong credentials or as! ParticleCompletionBlock no internet connectivity, please try again")
                // Print out more detailed information
                print(error?.localizedDescription)
            }
            else {
                print("Login success!")

                // try to get the device
                self.getDeviceFromCloud()

            }
        } // end login
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   

    // MARK: Get Device from Cloud
    // Gets the device from the Particle Cloud
    // and sets the global device variable
    func getDeviceFromCloud() {
        ParticleCloud.sharedInstance().getDevice(self.DEVICE_ID) { (device:ParticleDevice?, error:Error?) in
            
            if (error != nil) {
                print("Could not get device")
                print(error?.localizedDescription)
                return
            }
            else {
                print("Got photon from cloud: \(device?.id)")
                self.myPhoton = device
                
                // subscribe to events
                self.subscribeToParticleEvents()
            }
            
        } // end getDevice()
    }
    
    
    //MARK: Subscribe to "playerChoice" events on Particle
    func subscribeToParticleEvents() {
        self.shapeLabel.text = "△"
        var handler : Any?
        handler = ParticleCloud.sharedInstance().subscribeToDeviceEvents(
            withPrefix: "playerChoice",
            deviceID:self.DEVICE_ID,
            handler: {
                (event :ParticleEvent?, error : Error?) in
            
            if let _ = error {
                print("could not subscribe to events")
            } else {
                print("got event with data \(event?.data)")
                let choice = (event?.data)!
                if (choice == "A") {
                    self.turnParticleGreen()
                    self.gameScore = self.gameScore + 1;
                }
                else if (choice == "B") {
                    self.turnParticleRed()
                }else if (choice == "A" || choice == "B") {
                    self.shapeLabel.text = "▢"
                    if (choice == "B") {
                            self.turnParticleGreen()
                            self.gameScore = self.gameScore + 1;
                            }
                            else if (choice == "A") {
                            self.turnParticleRed()
                    }
                    
                }
            }
        })
    }
    
    
    
    func turnParticleGreen() {
        
        print("Pressed the change lights button")
        
        let parameters = ["green"]
        var task = myPhoton!.callFunction("answer", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to turn green")
            }
            else {
                print("Error when telling Particle to turn green")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        
    }
    
    func turnParticleRed() {
        
        print("Pressed the change lights button")
        
        let parameters = ["red"]
        var task = myPhoton!.callFunction("answer", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to turn red")
            }
            else {
                print("Error when telling Particle to turn red")
            }
        }
        //var bytesToReceive : Int64 = task.countOfBytesExpectedToReceive
        
    }
    
    
    @IBAction func testScoreButtonPressed(_ sender: Any) {
        
        print("score button pressed")
        
        // 1. Show the score in the Phone
        // ------------------------------
        self.scoreLabel.text = "Score:\(self.gameScore)"
        
        // 2. Send score to Particle
        // ------------------------------
        let parameters = [String(self.gameScore)]
        var task = myPhoton!.callFunction("score", withArguments: parameters) {
            (resultCode : NSNumber?, error : Error?) -> Void in
            if (error == nil) {
                print("Sent message to Particle to show score: \(self.gameScore)")
            }
            else {
                print("Error when telling Particle to show score")
            }
        }
        
        
        
        // 3. done!
        
        
    }
    
}

