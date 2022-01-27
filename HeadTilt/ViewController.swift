//
//  ViewController.swift
//  HeadTilt
//
//  Created by Pallav Agarwal
//  Twitter: @pallavmac

import UIKit
import CoreMotion

class ViewController: UIViewController, CMHeadphoneMotionManagerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    let manager = CMHeadphoneMotionManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        manager.delegate = self
        
        print("Authorized: ", CMAuthorizationStatus.authorized)
        
        manager.startDeviceMotionUpdates(
            to: OperationQueue.current!, withHandler: { [self]
            (deviceMotion, error) -> Void in
         
            if let motion = deviceMotion {
                let attitude = motion.attitude
                let roll = degrees(attitude.roll)
                let pitch = degrees(attitude.pitch)
                let yaw = degrees(attitude.yaw)
                
                let r = motion.rotationRate
                let ac = motion.userAcceleration
                let g = motion.gravity
                
                DispatchQueue.main.async { [self] in
                    var str = "Attitude:\n"
                    str += degreeText("Roll", roll)
                    str += degreeText("Pitch", pitch)
                    str += degreeText("Yaw", yaw)
                    
                    str += "\nRotation Rate:\n"
                    str += xyzText(r.x, r.y, r.z)
                    
                    str += "\nAcceleration:\n"
                    str += xyzText(ac.x, ac.y, ac.z)
                    
                    str += "\nGravity:\n"
                    str += xyzText(g.x, g.y, g.z)
                    
                    textView.text = str
                }
                
            } else {
                textView.text = "ERROR: \(error?.localizedDescription ?? "")"
            }
        })
    }
    
    func degreeText(_ label: String, _ num: Double) -> String {
        return String(format: "\(label): %.0fº\n", abs(num))
    }
    
    func xyzText(_ x: Double, _ y: Double, _ z: Double) -> String {
        // Absolute value just makes it look nicer
        var str = ""
        str += String(format: "X: %.1f\n", abs(x))
        str += String(format: "Y: %.1f\n", abs(y))
        str += String(format: "Z: %.1f\n", abs(z))
        return str
    }
    
    func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "AirPods Connected!"
    }
    
    func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        textView.text = "AirPods Disconnected :("
    }
    
    func degrees(_ radians: Double) -> Double { return 180 / .pi * radians }

}

