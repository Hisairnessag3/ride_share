//
//  DBProvider.swift
//  Ober
//
//  Created by Austin Glugla on 2/4/17.
//  Copyright © 2017 Portable Hats. All rights reserved.
//

import Foundation
import FirebaseDatabase

class DBProvider {
    private static let _instance = DBProvider();
    
    static var Instance: DBProvider {
        return _instance;
    }
    var dbRef: FIRDatabaseReference {
        return FIRDatabase.database().reference();
        
    }
    
    var ridersRef: FIRDatabaseReference {
        return dbRef.child(Constants.RIDERS);
    }
    
    //request reference
    
    var requestRef: FIRDatabaseReference {
        return dbRef.child(Constants.RIDE_REQUEST)
    }
    
    //requestAccepted
    
    var requestAcceptedRef: FIRDatabaseReference {
        return dbRef.child(Constants.RIDE_ACCEPTED)
    }
    
    func saveUser(withID: String, email: String, password: String) {
        let data: Dictionary<String, Any> = [Constants.EMAIL: email,
                                             Constants.PASSWORD: password, Constants.isRider: true];
        
        ridersRef.child(withID).child(Constants.DATA).setValue(data);
        
    }
    
}//class
