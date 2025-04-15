//
//  RunClubTabView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 14/4/25.
//

import SwiftUI

struct RunClubTabView: View {
    
    // MARK: VARIABLES
    
    @State var selectedTab = 0 /// Tracks the currently selected tab index
    
    var body: some View {
        TabView(selection: $selectedTab) {
            
            // HomeView as first tab
            HomeView()
                .tag(0)
                .tabItem {
                    Image(systemName: "figure.run")
                    
                    Text("Run")
                }
        }
    }
}

#Preview {
    RunClubTabView()
}
