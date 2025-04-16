//
//  PauseView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 15/4/25.
//

import SwiftUI
import MapKit
import AudioToolbox

struct PauseView: View {
    
    // MARK: VARIABLES
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            // MARK: MAP DISPLAY
            AreaMap(region: $runTracker.region)
                .ignoresSafeArea()
                .frame(height: 300)
            
            // MARK: DISTANCE, PACE, TIME DISPLAY
            HStack {
                VStack {
                    Text("\(runTracker.distance / 1000, specifier: "%.2f")")
                        .font(.title3)
                        .bold()
                    
                    Text("Km")
                }
                .frame(maxWidth: .infinity)
                
                // PACE
                VStack {
                    Text("\(runTracker.pace, specifier: "%.2f") min")
                        .font(.title3)
                        .bold()
                    
                    Text("Avg Pace")
                }
                .frame(maxWidth: .infinity)

                // TIME
                VStack {
                    Text("\(runTracker.elapsedTime.convertDurationToString())")
                        .font(.title3)
                        .bold()
                    
                    Text("Time")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            // MARK: PLACEHOLDER METRICS
            HStack {
                // Calories
                VStack {
                    Text("0")
                        .font(.title3)
                        .bold()
                    
                    Text("Calories")
                }
                .frame(maxWidth: .infinity)
                
                // Elevation
                VStack {
                    Text("0f")
                        .font(.title3)
                        .bold()
                    
                    Text("Elevation")
                }
                .frame(maxWidth: .infinity)

                // Heart Rate
                VStack {
                    Text("65")
                        .font(.title3)
                        .bold()
                    
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            
            // MARK: CONTROL BUTTONS
            HStack {
                Button {
                    // no action on tap of stop button
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                .simultaneousGesture(LongPressGesture().onEnded({ _ in
                    withAnimation {
                        runTracker.stopRun()
                        // Haptic feedback on stop
                        AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { }
                    }
                }))
                
                Spacer()
                
                // Pause Button
                Button {
                    withAnimation {
                        runTracker.resumeRun()
                    }
                } label: {
                    Image(systemName: "play.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}

#Preview {
    PauseView()
        .environmentObject(RunTracker())
}
