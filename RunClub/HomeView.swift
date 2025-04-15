//
//  HomeView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 13/4/25.
//

import SwiftUI
import MapKit

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
            .fullScreenCover(isPresented: $runTracker.presentPauseView) {
                PauseView()
                    .environmentObject(runTracker)
            }
        }
    }
}

#Preview {
    HomeView()
}
