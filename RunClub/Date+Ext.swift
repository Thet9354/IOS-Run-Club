//
//  Date+Ext.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 20/4/25.
//

import Foundation

extension Date {
    func formateDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: self)
    }
    
    func timeOfDayString() -> String {
        let hour = Calendar.current.component(.hour, from: self)
        switch hour {
        case 5..<11:
            return "Morning Run"
        case 11..<17:
            return "Lunch Run"
        case 17..<22:
            return "Evening Run"
        default:
            return "Nightowl Run"
        }
    }
}
