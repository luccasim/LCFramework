//
//  Int.swift
//  
//
//  Created by owee on 27/08/2020.
//

import Foundation

public extension Int {
    
    // MARK: - Description
    
    /// Returns the number format with degree char
    var descDegree : String {
        return self.description + "°"
    }
}
