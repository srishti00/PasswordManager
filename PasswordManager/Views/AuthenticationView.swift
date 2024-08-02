//
//  AuthenticationView.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//

import LocalAuthentication
import SwiftUI

struct AuthenticationView: View {
    @State private var isUnlocked = false

    var body: some View {
        VStack {
            // Show HomeView if authenticated, otherwise show the Unlock button
            if isUnlocked {
                HomeView()
            } else {
                Button("Unlock") {
                    authenticate() // Trigger authentication process
                }
            }
        }
    }

    // Function to handle authentication
    private func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports the authentication policy
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // Evaluate the authentication policy
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Access your passwords") { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Update state to unlocked if authentication is successful
                        isUnlocked = true
                    } else {
                        print("authentication failure")
                    }
                }
            }
        } else {
            print("biometric authentication is not available or configured")
        }
    }
}
