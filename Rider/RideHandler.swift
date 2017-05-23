//
//  RideHandler.swift
//  Ober
//
//  Created by Austin Glugla on 2/4/17.
//  Copyright © 2017 Portable Hats. All rights reserved.
//

import Foundation
import FirebaseDatabase

protocol RideController: class {
    
    func canCallRide(delegateCalled: Bool);
    
    func driverAcceptedRequest(requestAccepted: Bool, driverName: String);
    
    func updateDriversLocation(lat: Double, long: Double);
    
}

class RideHandler {
    private static let _instance = RideHandler();
    
    weak var delegate: RideController?;
    
    var rider = "";
    var driver = "";
    var rider_id = "";
    
    static var Instance: RideHandler {
        return _instance; }
    
    
    func observeMessagesForRider() {
        //rider requested ride
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childAdded) {(snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                        self.rider_id = snapshot.key;
                        self.delegate?.canCallRide(delegateCalled: true);
                        

                    }
                }
            }
        }
    

        //Driver accepted Ride
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childAdded) { (snapshot: FIRDataSnapshot) in
            if let data = snapshot.value as? NSDictionary {
                if let name = data [Constants.NAME] as? String {
                    if self.driver == "" {
                        self.driver =  name;
                        self.delegate?.driverAcceptedRequest(requestAccepted: true, driverName: self.driver);
                        
                        
                    }}
                    
            }}
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childRemoved){(snapshot: FIRDataSnapshot) in
            if let data  = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        self.driver = "";
                        self.delegate?.driverAcceptedRequest(requestAccepted: false, driverName: name);
                        
                    }
                }
            }
        }
        
        //driver updating location
        DBProvider.Instance.requestAcceptedRef.observe(FIRDataEventType.childChanged) { (snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.driver {
                        if let lat = data[Constants.LATITUDE] as? Double {
                            if let long = data[Constants.LONGITUDE] as? Double {
                                self.delegate?.updateDriversLocation(lat: lat, long: long);
                                
                            }
                        }
                        
                    }
                }
            }
            
            
        }
        //rider canceled ride
        DBProvider.Instance.requestRef.observe(FIRDataEventType.childRemoved) {(snapshot: FIRDataSnapshot) in
            
            if let data = snapshot.value as? NSDictionary {
                if let name = data[Constants.NAME] as? String {
                    if name == self.rider {
                        self.rider_id = snapshot.key;
                        self.delegate?.canCallRide(delegateCalled: false);
                        
                        
                    }
                }
            }
        }
    }
    
    
    
    func requestRide(latitude: Double, longitude: Double){
    
    let data: Dictionary<String, Any> = [Constants.NAME: self.rider, Constants.LATITUDE:
    latitude, Constants.LONGITUDE: longitude];
    
    DBProvider.Instance.requestRef.childByAutoId().setValue(data);
    
    }

    
    
    
   
    
    
    
    
        
                        
      
    

    func CancelRide() {
        DBProvider.Instance.requestRef.child(rider_id).removeValue();
    }

    
    func updateRiderLocation(lat: Double, long: Double) {
        DBProvider.Instance.requestRef.child(rider_id).updateChildValues([Constants.LATITUDE: lat, Constants.LONGITUDE: long]);
    }
    
    
    




        }//class
