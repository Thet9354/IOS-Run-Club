//
//  RunView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 14/4/25.
//

import SwiftUI

/// A view that displays live metrics during a run session, such as distance, pace, and elasped time.
/// Includes control buttons to pause or stop the run.
struct RunView: View {
    
    @EnvironmentObject var runTracker: RunTracker
    
    var body: some View {
        VStack {
            // Top row: Distance, BPM (placeholder, Pace)
            HStack {
                VStack {
                    // Distance display
                    Text("\(runTracker.distance, specifier: "%.2f") m")
                        .font(.title)
                        .bold()
                    
                    Text("Distance")
                }
                .frame(maxWidth: .infinity)
                 
                VStack {
                    // Placeholder for heart rate
                    Text("BPM")
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    // Pace Display
                    Text("\(runTracker.pace, specifier: "%.2f") km/min")
                        .font(.title)
                        .bold()
                    
                    Text("Pace")
                }
                .frame(maxWidth: .infinity)
            }
                        
            // Middle: Elaspe time display
            VStack {
                Text("\(runTracker.elapsedTime)")
                    .font(.system(size: 64))
                
                Text("Time")
                    .foregroundStyle(.gray)
            }
            .frame(maxHeight: .infinity)
                  
            // Bottom: Stop and Pause Buttons
            HStack {
                Button {
                    // TODO: Add stop functionality (e.g, end run and return to HomeView)
                } label: {
                    Image(systemName: "stop.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
                
                Spacer()
                
                // Pause Button
                Button {
                    // TODO: Add pause/resume functionality
                } label: {
                    Image(systemName: "pause.fill")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding(36)
                        .background(.black)
                        .clipShape(Circle())
                }
                .frame(maxWidth: .infinity)
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .background(.yellow)
    }
}

#Preview {
    RunView()
}
