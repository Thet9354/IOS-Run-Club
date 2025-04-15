//
//  HomeView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 13/4/25.
//

import SwiftUI
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
    @Published var distance = 0.0 // Total distance covered (in meters)
    @Published var pace = 0.0 // Pace in km/h
    @Published var elapsedTime = 0 // Elasped time in seconds
    
    // MARK: PRIVATE PROPERTIES
    private var timer: Timer?
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
        startLocation = nil
        lastLocation = nil
        distance = 0.0
        pace = 0.0
        
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

// MARK: AREAMAP VIEW

/// SwiftUI wrapper around MapKit's `Map` view that binds to a `MKCoordinateRegion`.
struct AreaMap: View {
    
    /// Binding to the map region for live updates.
    @Binding var region: MKCoordinateRegion
    
    var body: some View {
        let binding = Binding(
            get: { self.region },
            set: { newValue in
                DispatchQueue.main.async {
                    self.region = newValue
                }
            }
        )
        return Map(coordinateRegion: $region, showsUserLocation: true)
            .ignoresSafeArea()
    }
}

// MARK: HOMEVIEW

/// The landing page of the app that displays the live map and allows users to start a run
struct HomeView: View {
    
    /// StateObject to manage the run lifecycle and tracking.
    @StateObject var runTracker = RunTracker()
    
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack(alignment: .bottom) {
                    
                    AreaMap(region: $runTracker.region) /// Background map showing user's current location
                    
                    // Start button launches the countdown sequence
                    Button {
                        runTracker.presentCountDown = true
                    } label: {
                        Text("Start")
                            .bold()
                            .font(.title)
                            .foregroundStyle(.black)
                            .padding(36)
                            .background(.yellow)
                            .clipShape(Circle())
                    }
                    .padding(.bottom, 48)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .navigationTitle("Run")
            .fullScreenCover(isPresented: $runTracker.presentCountDown) {
                CountDownView()
                    .environmentObject(runTracker)
            }
            .fullScreenCover(isPresented: $runTracker.presentRunView) {
                RunView()
                    .environmentObject(runTracker)
            }
        }
    }
}

#Preview {
    HomeView()
}
