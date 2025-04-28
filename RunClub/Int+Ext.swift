//
//  Int+Ext.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 15/4/25.
//

import Foundation

/// Extension to format Int values representing durations (in seconds) into human-readable time formats
extension Int {
    
    /// COnverts the integer (seconds) into hours, minutes, and seconds
    ///  - Returns: A tuple of (hours, minutes, seconds)
    public func hmsFrom() -> (Int, Int, Int) {
        return (self / 3600, (self % 3600) / 60, (self % 3600) % 60)
    }
    
    /// Converts a duration (seconds) into a formatted string like "HH:MM:SS" or "MM:SS" depending on the value.
    /// - Returns: A formatted duration string
    public func convertDurationToString() -> String {
        var duration = ""
        let (hour, minute, second) = self.hmsFrom()
        if (hour > 0) {
            duration = self.getHour(hour: hour)
        }
        return "\(duration)\(self.getMinute(minute: minute))\(self.getSecond(second: second))"
     }
    
    /// Formats the hour component to always have two digits
    /// - Parameter hour: The number of hours
    /// - Returns: A formatted string for hours (e.g., "01:").
    private func getHour(hour: Int) -> String {
        var duration = "\(hour):"
        if (hour < 10) {
            duration = "0\(hour):"
        }
        return duration
    }
    
    /// Formats the minute component to always have two digits
    ///  - Parameter minute: The number of minutes
    ///  - Returns: A formatted string for minutes (e.g., "05:").
    private func getMinute(minute: Int) -> String {
        if (minute == 0) {
            return "00:"
        }
        
        if (minute < 10) {
            return "0\(minute):"
        }
        
        return "\(minute):"
    }
    
    /// Formats the second component to always have two digits.
        /// - Parameter second: The number of seconds.
        /// - Returns: A formatted string for seconds (e.g., "09").
    private func getSecond(second: Int) -> String {
        if (second == 0) {
            return "00"
        }
        
        if (second < 10) {
            return "0\(second)"
        }
        return "\(second)"
    }
}
