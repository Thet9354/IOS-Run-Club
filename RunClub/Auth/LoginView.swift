//
//  LoginView.swift
//  RunClub
//
//  Created by Phoon Thet Pine on 16/4/25.
//

import SwiftUI

/// It leverages Supabase magic link (OTP-based authentication) to securely log in users.
struct LoginView: View {
    
    // MARK: VARIABLES
    @State var email = ""
    
    var body: some View {
        VStack {
            Image("running")
                .resizable()
                .scaledToFit()
                .frame(width: 200,height: 400)
            
            Text("Welcome Runners")
                .font(.largeTitle)
                .bold()
                .frame(maxHeight: .infinity)
                        
            VStack {
                // MARK: EMAIL TEXT FIELD
                TextField("E-mail", text: $email)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(Color.primary)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                
                // MARK: LOGIN BUTTON
                Button {
                    Task {
                        do {
                            // Attempt to send magic link email using AuthService
                            try await AuthService.shared.magicLinkLogic(email: email)
                        } catch {
                            // Handle error (can be improved with user-facing alert)
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    Text("Login")
                        .bold()
                        .padding()
                        .frame(maxWidth: .infinity)
                        .foregroundStyle(.black)
                        .background(Color.yellow)
                        .clipShape(Capsule())
                }
                .disabled(email.count < 7) // Disable button when email input is too short to be valid
            }
            .padding()
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
        // MARK: HANDLE MAGIC LINK CALLBACK
        .onOpenURL { url in
            Task {
                do {
                    // Hanlde URL that user is redirected to after clicking magic link
                    try await AuthService.shared.handleOpenURL(url: url)

                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

#Preview {
    LoginView()
}
