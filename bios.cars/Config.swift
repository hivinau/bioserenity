//
//  Config.swift
//  bios.cars
//
//  Created by iOS Developer on 22/07/2017.
//  Copyright © 2017 fdapps. All rights reserved.
//

import UIKit
public class Config {
    
    /**
     Load values from config.plist.
     
     - Returns: values mapped with key string.
     */
    
    public static func value(forKey key: String) -> Any? {
        
        if let values = Config.loadValues(of: "config") {
        
            return values[key]
        }
        
        return nil
    }
    
    private static func loadValues(of file: String) -> Dictionary<String,Any>? {
        
        var content: Dictionary<String,Any>? = nil
        
        if let c = Config.content(of: file) as? Dictionary<String,Any> {
            
            content = c
        }
        
        return content
    }
    
    private static func content(of file: String) -> Any? {
        
        var content: Any? = nil
        
        if let path = Bundle.main.path(forResource: file, ofType: "plist") {
            
            let url = URL(fileURLWithPath: path)
            
            do {
                
                let data = try Data(contentsOf: url)
                
                content = try PropertyListSerialization.propertyList(from: data, options: .mutableContainers, format: nil)
                
            } catch {
                
            }
        }
        
        return content
    }
}

