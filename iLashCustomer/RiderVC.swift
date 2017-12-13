//
//  RiderVC.swift
//  Uber App For Rider
//
//  Created by MacBook on 10/23/16.
//  Copyright © 2016 Awesome Tuts. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UberController {

    @IBOutlet weak var myMap: MKMapView!
    
    @IBOutlet weak var callUberBtn: UIButton!
    @IBOutlet weak var Scheduleservice: UIButton!
    
    @IBOutlet weak var slideViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var slideView: UIView!
    @IBOutlet weak var closeMenuButton: UIButton!
    
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
    private var driverLocation: CLLocationCoordinate2D?;
    
    private var timer = Timer();
    
    private var canCallUber = true;
    private var riderCanceledRequest = false;
    
    private var appStartedForTheFirstTime = true;
    
    var menuShowing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeLocationManager();
        UberHandler.Instance.observeMessagesForRider();
        UberHandler.Instance.delegate = self;
        setUpSlideView()
    }
    
    private func initializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // if we have the coordinates from the manager
        if let location = locationManager.location?.coordinate {
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            myMap.setRegion(region, animated: true);
            
            myMap.removeAnnotations(myMap.annotations);
            
            if driverLocation != nil {
                if !canCallUber {
                    let driverAnnotation = MKPointAnnotation();
                    driverAnnotation.coordinate = driverLocation!;
                    driverAnnotation.title = "Driver Location";
                    myMap.addAnnotation(driverAnnotation);
                }
            }
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = userLocation!;
            annotation.title = "Drivers Location";
            myMap.addAnnotation(annotation);
            
        }
        
    }
    
    @objc func updateRidersLocation() {
        UberHandler.Instance.updateRiderLocation(lat: userLocation!.latitude, long: userLocation!.longitude);
    }
    
    func canCallUber(delegateCalled: Bool) {
        if delegateCalled {
            callUberBtn.setTitle("Cancel Uber", for: UIControlState.normal);
            canCallUber = false;
        } else {
            callUberBtn.setTitle("Call Uber", for: UIControlState.normal);
            canCallUber = true;
        }
    }
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        
        if !riderCanceledRequest {
            if requestAccepted {
                alertTheUser(title: "Service Accepted", message: "\(driverName) Accepted Your Service Request")
            } else {
                UberHandler.Instance.cancelUber();
                timer.invalidate();
                alertTheUser(title: "Service Canceled", message: "\(driverName) Canceled Service Request")
            }
        }
        riderCanceledRequest = false;
    }

    func updateDriversLocation(lat: Double, long: Double) {
        driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long);
    }
    @IBAction func scheduleservice(_ sender: AnyObject) {

    }
    @IBAction func callUber(_ sender: AnyObject) {
        if userLocation != nil {
            if canCallUber {
                UberHandler.Instance.requestUber(latitude: Double(userLocation!.latitude), longitude: Double(userLocation!.longitude))
                
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(RiderVC.updateRidersLocation), userInfo: nil, repeats: true);
                
            } else {
                riderCanceledRequest = true;
                UberHandler.Instance.cancelUber();
                timer.invalidate();
            }
        }
    }
    
    @IBAction func logout(_ sender: AnyObject) {
        if AuthProvider.Instance.logOut() {
            
            if !canCallUber {
                UberHandler.Instance.cancelUber();
                timer.invalidate();
            }
            
            dismiss(animated: true, completion: nil);
            
        } else {
            // problem with loging out
            alertTheUser(title: "Could Not Logout", message: "We could not logout at the moment, please try again later");
        }
    }
    
    private func alertTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
    }
    
    @IBAction func menuClicked(_ sender: UIButton) {
        if (menuShowing){
            slideViewConstraint.constant = -160
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()})
            closeMenuButton.isHidden = true
        }else{
            slideViewConstraint.constant = 10
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()})
            closeMenuButton.isHidden = false
        }
        menuShowing = !menuShowing
    }
    
    @IBAction func menuClosed(_ sender: UIButton) {
        slideViewConstraint.constant = -160
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()})
        closeMenuButton.isHidden = true
        menuShowing = !menuShowing
        }
        
    
} // class

extension RiderVC{
    func setUpSlideView(){
        blurView.layer.cornerRadius = 15
        slideView.layer.shadowOpacity = 1
        slideView.layer.shadowRadius = 5
        slideViewConstraint.constant = -160
    }
    
    
}



































