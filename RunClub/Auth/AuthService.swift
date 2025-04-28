//
//  AuthService.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 16/4/25.
//

import Foundation
import Supabase

/// Holds sensetive credentias required to connect to Supabase backend
struct Secrets {
    static let supbaseURL = URL(string: "Enter your supbaseURL here")!
    static let supabaseKey = "Enter your supabaseKey here"
}

/// Singleton class that handles authentication logic using Supabase
/// It manages session states, login with magic lik, handling deep link callbacks, and logout operations
@Observable
final class AuthService {
    
    /// Shared singleton instance of the AuthServices.
    static let shared = AuthService()
    
    /// Instance of the Supabase client intialized with URL and API key
    private var supabase = SupabaseClient(supabaseURL: Secrets.supbaseURL, supabaseKey: Secrets.supabaseKey)
    
    /// Holds current authenticated session, if there's any
    var currentSession: Session?
    
    /// Private initializer to enforece singleton pattern
    /// Also tries to fetch the current session upo app launch
    private init () {
        Task {
            currentSession = try? await supabase.auth.session
        }
    }
    
    /// Sends magic link emal to the given user email
    /// Allows user to sign in via OTP without password
    ///  - Parameter email: The user's email address
    func magicLinkLogic(email: String) async throws {
        try await supabase.auth.signInWithOTP(
            email: email,
            redirectTo: URL(string: "com.run-club-fll://login-callback")!
        )
    }
    
    /// Handles authentication callback URL after user taps the magic link
    /// - Paramter url: The deep link received from the magic link email
    func handleOpenURL(url: URL) async throws {
        currentSession = try await supabase.auth.session(from: url)
    }
    
    /// Logs the user out and clears the current session
    func logout() async throws {
        try await supabase.auth.signOut()
        currentSession = nil
    }
}
