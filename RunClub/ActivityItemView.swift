//
//  ActivityItemView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 20/4/25.
//

import SwiftUI
import MapKit

struct ActivityItemView: View {
    
    // MARK: - VARIABLES
    
    /// The run data to display
    var run: RunPayLoad
    
    var body: some View {
        VStack(alignment: .leading) {
            /// Title of the run (hardcoded as "Morning Run" for now)
            Text(run.createdAt.timeOfDayString())
                .font(.title3)
                .bold()
            
            /// Date when the run was created
            Text(run.createdAt.formateDate())
                .font(.caption)
            
            /// Run details section: DIstance, Pace, and Time
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
                    
                    Text("\(Int(run.pace)) min")
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
            
            /// Map showing the route of the run
            Map {
                MapPolyline(coordinates: convertRouteToCoordinate(geoJSON: run.route))
                    .stroke(.yellow, style: StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
    
    // MARK: - FUNCTIONS
    
    /// Converts a list of GeoJSONCoordniate into CLLocationCoordinate2D for displaying on the map
    ///  - Parameter geoJSON: The array of GeoJSONCoordinates from the run
    ///  - Returns: An array of CLLocationCOordnate2D points to be used in MapPolyline
    func convertRouteToCoordinate(geoJSON: [GeoJSONCoordinate]) -> [CLLocationCoordinate2D] {
        return geoJSON.map {CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
    }
}

#Preview {
    ActivityItemView(run: RunPayLoad(createdAt: .now, userId: .init(), distance: 123456, pace: 123, time: 1241, route: []))
}
