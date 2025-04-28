//
//  ActivityView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 17/4/25.
//

import SwiftUI

struct ActivityView: View {
    
    // MARK: - VARIABLES
    
    /// Stores the list of runs fetched from the database
    @State var activities = [RunPayLoad] ()
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                ForEach(activities) { run in
                    NavigationLink {
                        /// Navigate to a detailed view of a selected run
                        ActivityItemView(run: run)
                    } label: {
                        // Layout for each run item in the list
                        VStack(alignment: .leading) {
                            Text(run.createdAt.timeOfDayString())
                                .font(.title3)
                                .bold()
                            
                            Text(run.createdAt.formateDate())
                                .font(.caption)
                            
                            HStack(spacing: 24) {
                                VStack(alignment: .leading) {
                                    Text("Distance")
                                        .font(.caption)
                                    
                                    Text("\(run.distance / 1000, specifier: "%.2f") km")
                                        .font(.headline)
                                        .bold()
                                }
                                
                                VStack {
                                    Text("Pace")
                                        .font(.caption)
                                    
                                    Text("\(run.pace, specifier: "%.2f") min")
                                        .font(.headline)
                                        .bold()
                                }
                                
                                VStack {
                                    Text("Time")
                                        .font(.caption)
                                    
                                    Text("\(run.time.convertDurationToString())")
                                        .font(.headline)
                                        .bold()
                                }
                            }
                            .padding(.vertical)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }

                }
            }
            .listStyle(.plain) /// Remove default list separators
            .navigationTitle("Activity") /// title at the top of the page
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    /// Logout button at the top right corner
                    Button(role: .destructive) {
                        Task {
                            do {
                                try await AuthService.shared.logout()
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    } label: {
                        Text("Logout")
                    }
                }
            }
            .onAppear {
                /// Fetch activities when the view appears
                Task {
                    do {
                        guard let userId = AuthService.shared.currentSession?.user.id else { return }
                        activities = try await DatabaseService.shared.fetchWorkouts(for: userId)
                        activities.sort(by: { $0.createdAt >= $1.createdAt })
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
    /// Formats a Dtae into a readable string format (MM/dd/yyyy)
    /// - Parameter date: The date to format
    /// - Returns: A formatted date string
    func formateDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter.string(from: date)
    }
}

#Preview {
    ActivityView()
}
