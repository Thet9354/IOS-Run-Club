//
//  HealthManager.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 26/4/25.
//

import Foundation
import HealthKit

final class HealthManager {
    let healthStore = HKHealthStore()
    
    static let shared = HealthManager()
    private init() { }
    
    func requestAuthorization() async throws {
        let typeToShare: Set = [HKWorkoutType.workoutType()]
        
        try await healthStore.requestAuthorization(toShare: typeToShare, read: [])
    }
    
    func addWorkout(startDate: Date, endDate: Date, duration: TimeInterval, distance: Double, kCalBurned: Double) async throws {
        let workout = HKWorkout(activityType: .running,
                                start: startDate,
                                end: endDate,
                                duration: duration,
                                totalEnergyBurned: HKQuantity(unit: .kilocalorie(), doubleValue: kCalBurned),
                                totalDistance: HKQuantity(unit: .meter(), doubleValue: distance),
                                metadata: nil)
        
        try await healthStore.save(workout)
    }
    
    
}
