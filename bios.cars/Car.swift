//
//  Car.swift
//  bios.cars
//
//  Created by iOS Developer on 22/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import Foundation

@objc(Car)
public class Car: NSObject {
    
    private var _brand: String?
    private var _name: String?
    private var _speedMax: Int?
    private var _cv: Int?
    private var _currentSpeed: Int?
    
    public var brand: String? {
        
        get {
            
            return _brand
        }
    }
    
    public var name: String? {
        
        get {
            
            return _name
        }
    }
    
    public var speedMax: Int? {
        
        get {
            
            return _speedMax
        }
    }
    
    public var cv: Int? {
        
        get {
            
            return _cv
        }
    }
    
    public var currentSpeed: Int? {
        
        get {
            
            return _currentSpeed
        }
    }
    
    public init(brand: String?, name: String?, speedMax: Int?, cv: Int?, currentSpeed: Int?) {
        super.init()
        
        self._brand = brand
        self._name = name
        self._speedMax = speedMax
        self._cv = cv
        self._currentSpeed = currentSpeed
    }
}

public func ==(lhs: Car, rhs: Car) -> Bool {
    
    return (lhs.name == rhs.name) && (lhs.brand == rhs.brand) && (lhs.cv == rhs.cv)
}
