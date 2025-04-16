//
//  AuthService.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 16/4/25.
//

import Foundation
import Supabase

struct Secrets {
    static let supbaseURL = URL(string: "https://mcguanfjvtktzszursay.supabase.co")!
    static let supabaseKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1jZ3VhbmZqdnRrdHpzenVyc2F5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4MDY0MDMsImV4cCI6MjA2MDM4MjQwM30.gQTVmFwFBRohdN9TzVljP1nNmHO3W_ScO__Se-cqQqo"
}

@Observable
final class AuthService {
    
    static let shared = AuthService()
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
    
    var currentSession: Session?
    
    private init () {
        Task {
            currentSession = try? await supabase.auth.session
        }
    }
    
    func magicLinkLogic(email: String) async throws {
        try await supabase.auth.signInWithOTP(
            email: email,
            redirectTo: URL(string: "com.run-club-fll://login-callback")!
        )
    }
    
    func handleOpenURL(url: URL) async throws {
        currentSession = try await supabase.auth.session(from: url)
    }
    
    func logout() async throws {
        try await supabase.auth.signOut()
        currentSession = nil
    }
}
