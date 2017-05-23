//
//  RiderVC.swift
//  Ober
//
//  Created by Austin Glugla on 2/3/17.
//  Copyright © 2017 Portable Hats. All rights reserved.
//

import UIKit
import MapKit

class RiderVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, RideController{
    
    

    @IBOutlet weak var MyMap: MKMapView!
   
    @IBOutlet weak var callRideBtn: UIButton!
    
    private var locationManager = CLLocationManager();
    private var userLocation: CLLocationCoordinate2D?;
    private var driverLocation : CLLocationCoordinate2D?;
    
    private var timer = Timer();
    
    private var canCallRide = true;
    private var riderCanceledRide = false;
    
    private var appStartedForTheFirstTime = true;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        intializeLocationManager();
        RideHandler.Instance.observeMessagesForRider();
        RideHandler.Instance.delegate = self;
    }
    
    
    private func intializeLocationManager() {
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.requestWhenInUseAuthorization();
        locationManager.startUpdatingLocation();
        
    }
    //if we have coordinates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locationManager.location?.coordinate {
            
            
            userLocation = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            
            let region = MKCoordinateRegion(center: userLocation!, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01));
            
            MyMap.setRegion(region, animated: true);
            
            MyMap.removeAnnotations(MyMap.annotations)
            
            if driverLocation  != nil {
                if !canCallRide {
                    let driverAnnotation = MKPointAnnotation();
                    driverAnnotation.coordinate = driverLocation!;
                    driverAnnotation.title = "Driver Location";
                    MyMap.addAnnotation(driverAnnotation);
                }
            }
            
            let annotation = MKPointAnnotation();
            annotation.coordinate = userLocation!;
            annotation.title = "Drivers Location";
            MyMap.addAnnotation(annotation);
        }
    }
    
    func updateRidersLocation() {
        RideHandler.Instance.updateRiderLocation(lat: userLocation!.latitude, long: userLocation!.longitude);
    }
    
    func canCallRide(delegateCalled: Bool) {
        if delegateCalled {
            callRideBtn.setTitle("Cancel Ride", for: UIControlState.normal);
            canCallRide = false;
        } else {
            callRideBtn.setTitle("Call Uber", for: UIControlState.normal);
            canCallRide = true;
        }
                       }
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String) {
        
        if !riderCanceledRide{
            if requestAccepted {
                alterTheUser(title: "Ride Accepted", message: "\(driverName) Accepted your ride request")
                
            }else{
                RideHandler.Instance.CancelRide()
                timer.invalidate();
                
                alterTheUser(title: "Ride Canceled", message: "\(driverName) Canceled Ride Request")

            }
            
            
            
        }
        riderCanceledRide = false; 
        
    }
    func updateDriversLocation(lat: Double, long: Double) {
        driverLocation = CLLocationCoordinate2D(latitude: lat, longitude: long);
    }
    
    
    @IBAction func CallRide(_ sender: Any) {
    
    
        if userLocation != nil {
            if canCallRide { RideHandler.Instance.requestRide(latitude: Double(userLocation!.latitude), longitude: Double(userLocation!.longitude))
                
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(RiderVC.updateRidersLocation), userInfo: nil, repeats: true);
                
            }else {
                riderCanceledRide = true;
                RideHandler.Instance.CancelRide();
                timer.invalidate();
                //cancel uber
            }
        
        
    
    }
    }
   
    
    
    @IBAction func Signout(_ sender: Any) {
        if AuthProvider.Instance.logOut() {
            
            if !canCallRide{
                RideHandler.Instance.CancelRide();
                timer.invalidate();
            }
            
            
            
            
        }else {
            //Problem with sign out
            alterTheUser(title: "Could not logout", message: "Unable to complete Sign Out process :O");
        }
    }
    private func alterTheUser(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle:  .alert);
        let ok = UIAlertAction(title: "OK", style: .default, handler: nil);
        alert.addAction(ok);
        present(alert, animated: true, completion: nil);
        
    }


  }//class
