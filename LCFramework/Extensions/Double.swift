//
//  Double.swift
//  
//
//  Created by owee on 27/08/2020.
//

import Foundation

extension Double {
    
    // MARK: - Description
            
    /// Return the number formatted like a integer.
    var descInt : String {
        return Int(self).description
    }
    
    /// Returns the number format with degree char
    var descDegree : String {
        return self.description + "°"
    }
    
    /// Returns the number with cent precision
    var descCent : String {
        return String(format: "%.2f", self)
    }
    
    /// Returns the number with mil precision
    var descMil : String {
        return String(format: "%.3f", self)
    }
    
}
