//
//  DatabaseService.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 17/4/25.
//

import Foundation
import Supabase

struct Table {
    static let workouts = "workouts"
}

// MARK: - DATA MODEL
struct RunPayLoad: Identifiable, Codable {
    var id: Int?
    var createdAt: Date
    let userId: UUID
    let distance: Double
    let pace: Double
    let time: Int
    let route: [GeoJSONCoordinate]
    
    enum CodingKeys: String, CodingKey {
        case id, distance, pace, time, route
        case createdAt = "created_at"
        case userId = "user_id"
    }
}

struct GeoJSONCoordinate: Codable {
    let longitude: Double
    let latitude: Double
}



// MARK: - DATABASE SERVICE
final class DatabaseService {
    
    static let shared = DatabaseService()
    
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
    
    private init() {}
    
    // MARK: CRUD OPERATIONS
    
    /// Saves a new workout to the "workouts" table in Supabase
    ///
    /// - Parameter run: A RunPayLoad object containing workout details
    func saveWorkout(run: RunPayLoad) async throws {
        let _ = try await supabase.from(Table.workouts).insert(run).execute().value
    }
    
    /// Fetches all workout entries from the "workouts" table
    ///
    /// - Returns: An array of 'RunPayLoad' obejcts
    /// - Throws: An error if the fetch operation fails
    func fetchWorkouts(for userId: UUID) async throws -> [RunPayLoad] {
        return try await supabase.from(Table.workouts).select().in("user_id", values: [userId]).execute().value
    }
}


