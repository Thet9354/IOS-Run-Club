//
//  CountDownView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 14/4/25.
//

import SwiftUI

/// A full-screen countdown view that displays a 3-second countdown before starting a run.
/// Once the coutndown ends, it dismisses itself and triggers the run flow via 'RunTracker'.
struct CountDownView: View {
    
    
    @EnvironmentObject var runTracker: RunTracker /// Shared run tracking state, injected from the enviornment
    @State var timer: Timer? /// Countdown timer reference
    @State var countdown = 3 /// Current countdown value in seconds
    
    var body: some View {
        Text("\(countdown)")
            .font(.system(size: 256))
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.yellow)
            .onAppear {
                setUpCountDown()
            }
    }
    
    /// Starts the countdow timer. Once the countdown reaches zero,
    /// it stops the timers, dismisses the countdown view, and starts the run.
    func setUpCountDown() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            if countdown <= 1 {
                timer?.invalidate() /// Countdown complete
                timer = nil
                runTracker.presentCountDown = false /// Dismiss this view
                runTracker.startRun() /// Begin the run
            } else {
                countdown -= 1 /// Countine count down
            }
        })
    }
}

#Preview {
    CountDownView()
        .environmentObject(RunTracker())
}
