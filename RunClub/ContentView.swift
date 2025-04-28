//
//  ContentView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 13/4/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if let session = AuthService.shared.currentSession {
            RunClubTabView()
                .task {
                    do {
                        try await HealthManager.shared.requestAuthorization()
                    } catch {
                        print(error.localizedDescription)
                    }
                }
        } else {
            LoginView()
        }
    }
}

#Preview {
    ContentView()
}
