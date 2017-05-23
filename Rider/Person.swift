//
//  Person.swift
//  Ober
//
//  Created by Austin Glugla on 2/2/17.
//  Copyright © 2017 Portable Hats. All rights reserved.
//

import Foundation
class Person {
    private var _name = "Name";
    private var _lastName = "Last Name";
    
    var name: String {
        get{
            return _name;
        }
        set{
            _name = newValue;
        }
   
    }
    var lastName: String {
        get{
            return _lastName;
        }
        set {
            _lastName = newValue;
        
    }
       
        
        }
    func getWholeName() -> String {
        return "\(name) \(lastName)";
        
}
}
