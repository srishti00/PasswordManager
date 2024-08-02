//
//  AuthenticationViewModel.swift
//  PasswordManager
//
//  Created by srisshar on 02/08/24.
//

import LocalAuthentication
import SwiftUI

class AuthenticationViewModel: ObservableObject {
    @Published var isUnlocked = false // Published property to track authentication status

    // Function to handle biometric authentication
    func authenticate() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."

            // Evaluate the biometric authentication policy
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        self.isUnlocked = true
                    } else {
                        print("Authentication failed")
                        
                    }
                }
            }
        } else {
            print("No biometrics available or not configured")
            self.isUnlocked = true 
        }
    }
}
