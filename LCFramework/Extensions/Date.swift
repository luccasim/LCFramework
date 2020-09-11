//
//  Date.swift
//  
//
//  Created by owee on 27/08/2020.
//

import Foundation

extension Date {
    
    // MARK: - Descriptions
    
    /// Returns the day of the week
    var descDay : String {
        let formater = DateFormatter()
        formater.dateFormat = "EEEE"
        return formater.string(from: self)
    }
    
    /// Returns hourly as HH:mm
    var descHourlyHM : String {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm"
        return formater.string(from: self)
    }
    
    /// Returns hourly as HH:mm:ss
    var descHourlyHMS : String {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm:ss"
        return formater.string(from: self)
    }
    
    /// Return the short date without houlry
    var descDate : String {
        let formater = DateFormatter()
        formater.dateFormat = "HH:mm:ss"
        return formater.string(from: self)
    }
    
    /// Returns the full date format
    var descDateFull : String {
        let formater = DateFormatter()
        formater.dateFormat = "EEE, d MMM yyyy HH:mm:ss"
        return formater.string(from: self)
    }
    
    /// Returns the short date format
    var descDateShort : String {
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd-yyyy HH:mm"
        return formater.string(from: self)
    }
    
}
