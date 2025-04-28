//
//  RunTracker.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 15/4/25.
//

import Foundation
import MapKit

// MARK: - RUNTRACKER
/// Observable class that manages run session data, including location tracking, distance,
/// Pace calculation, and session control (countdown/start)

class RunTracker: NSObject, ObservableObject {
    
    // MARK: - Published Properties (State)
    
    // The current region displayed on the map
    @Published var region = MKCoordinateRegion(center: .init(latitude: 1.290270, longitude: 103.851959), span: .init(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    @Published var isRunning = false // Wether the user is currently running
    @Published var presentCountDown = false // Controls the visibility of the countdown screen
    @Published var presentRunView = false // Controls the visibility of the run screen
    @Published var presentPauseView = false
    @Published var distance = 0.0 // Total distance covered (in meters)
    @Published var pace = 0.0 // Pace in km/h
    @Published var elapsedTime = 0 // Elasped time in seconds
    @Published var locations = [CLLocationCoordinate2D]()
    
    // MARK: PRIVATE PROPERTIES
    private var timer: Timer?
    private var startTime = Date.now
    private var locationManager: CLLocationManager?
    private var startLocation: CLLocation?
    private var lastLocation: CLLocation?
    
    
    
    // MARK: INITIALIZER
    override init() {
        super.init()
        
        Task {
            await MainActor.run {
                locationManager = CLLocationManager()
                locationManager?.delegate = self
                locationManager?.requestWhenInUseAuthorization()
                locationManager?.startUpdatingLocation()
            }
        }
    }
    
    // MARK: RUN CONTROL LOGIC
    
    // Begins a new run session: resets distance, time, starts location tracking and timer
    func startRun() {
        presentRunView = true
        isRunning = true
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        elapsedTime = 0
        startTime = .now
        
        // Start a timer that ticks every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            // Calculate pace if distance is non-zero
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60) / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func resumeRun() {
        isRunning = true
        presentPauseView = false
        presentRunView = true
        startLocation = nil
        lastLocation = nil
        // Start a timer that ticks every second
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self else { return }
            self.elapsedTime += 1
            // Calculate pace if distance is non-zero
            if self.distance > 0 {
                pace = (Double(self.elapsedTime) / 60) / (self.distance / 1000)
            }
        }
        locationManager?.startUpdatingLocation()
    }
    
    func pauseRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = true
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
    }
    
    func stopRun() {
        isRunning = false
        presentRunView = false
        presentPauseView = false
        locationManager?.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
        postToDatabase()
        postToHealthStore()
    }
    
    func postToDatabase() {
        Task {
            do {
                guard let userId = AuthService.shared.currentSession?.user.id else { return }
                let run = RunPayLoad(createdAt: .now, userId: userId, distance: distance, pace: pace, time: elapsedTime, route: convertToGeoJSONCoordinates(locations: locations))
                try await DatabaseService.shared.saveWorkout(run: run)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func postToHealthStore() {
        Task {
            do {
                try await HealthManager.shared.addWorkout(startDate: startTime, endDate: .now, duration: Double(elapsedTime), distance: distance, kCalBurned: calculateKCalBurned())
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func calculateKCalBurned() -> Double {
        let weight: Double = 75
        let duration: Double = Double(elapsedTime) / (60*60)
        
        let kilos: Double = (distance/1000)
        let met: Double = (1.57) * (kilos/duration) - 3.15
        
        return met * weight * duration
    }
}

// MARK: Location Tracking
extension RunTracker: CLLocationManagerDelegate {
    
    /// Called whenever the location manager receives updated location info.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Update the map view to center on the user's current location
        DispatchQueue.main.async { [weak self] in
            self?.region.center = location.coordinate
        }
        
        self.locations.append(location.coordinate)
        
        // Set the start location if this is the first update
        if startLocation == nil {
            startLocation = location
            lastLocation = location
            return
        }
        
        // Accumulate distance from last known location
        if let lastLocation {
            distance += lastLocation.distance(from: location)
        }
        lastLocation = location
    }
}

func convertToGeoJSONCoordinates(locations: [CLLocationCoordinate2D]) -> [GeoJSONCoordinate] {
    return locations.map { GeoJSONCoordinate(longitude: $0.longitude, latitude: $0.latitude) }
}
