//
//  AddPasswordView.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//

import SwiftUI

struct AddPasswordSheetView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var accountType = "" // State for account type input
    @State private var username = "" // State for username input
    @State private var password = "" // State for password input
    @State private var isPasswordVisible = false // State for password visibility
    
    @State private var accountTypeError: String? = nil // State for account type error message
    @State private var usernameError: String? = nil // State for username error message
    @State private var passwordTextError: String? = nil // State for password error message

    var body: some View {
        VStack {
            // Main form for adding a new password
            VStack(spacing: 25) {
                // Custom text fields for account type and username
                CustomTextField(placeholder: "Account Name", text: $accountType, error: $accountTypeError)
                CustomTextField(placeholder: "UserName/Email", text: $username, error: $usernameError)
                
                // Custom secure field for password with strength indicator and generator button
                VStack(alignment: .leading, spacing: 5) {
                    CustomSecureField(placeholder: "Password", text: $password, isPasswordVisible: $isPasswordVisible, error: $passwordTextError)
                    HStack {
                        // Display password strength view if password is not empty
                        if !password.isEmpty {
                            PasswordStrengthView(password: $password)
                        }
                        
                        Spacer()
                        
                        // Button to generate a random password
                        Button(action: {
                            password = PasswordGenerator.generatePassword()
                        }) {
                            Text("Generate Password")
                                .foregroundColor(.blue)
                                .font(.system(size: 14))
                                .padding()
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding([.leading, .trailing], 10)

            // Button to submit the new password entry
            Button(action: {
                if validateInput() {
                    savePassword()
                }
            }) {
                Text("Add New Account")
                    .font(.headline)
                    .foregroundColor(.white)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color("ButtonColor"))
                    .cornerRadius(20)
                    .padding(.horizontal)
            }
            .padding(.top, 30)

            Spacer()
        }
        .padding(.top, 60) // Top padding for the entire view
    }
    
    // Function to validate user input
    private func validateInput() -> Bool {
        var isValid = true
        
        // Check if account type is empty
        if accountType.isEmpty {
            accountTypeError = "Account Type is required."
            isValid = false
        } else {
            accountTypeError = nil
        }
        
        // Check if username is empty
        if username.isEmpty {
            usernameError = "Email is required."
            isValid = false
        } else {
            usernameError = nil
        }
        
        // Check if password is empty
        if password.isEmpty {
            passwordTextError = "Password is required."
            isValid = false
        } else {
            passwordTextError = nil
        }
        
        return isValid
    }

    // Function to save the new password entry to Core Data
    private func savePassword() {
        let newPassword = PasswordEntity(context: viewContext)
        newPassword.accountType = accountType
        newPassword.username = username
        if let encryptedPassword = EncryptionHelper.encrypt(password) {
            newPassword.password = encryptedPassword
        }
        do {
            try viewContext.save()
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            // TextField with placeholder and binding for text input
            TextField(placeholder, text: $text)
                .padding()
                .font(.system(size: 14))
                .fontWeight(.semibold)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .cornerRadius(8)
                .frame(height: 44)
            // Display error message if any
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}

struct CustomSecureField: View {
    var placeholder: String
    @Binding var text: String
    @Binding var isPasswordVisible: Bool
    @Binding var error: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                // Display TextField or SecureField based on password visibility
                if isPasswordVisible {
                    TextField(placeholder, text: $text)
                        .padding()
                } else {
                    SecureField(placeholder, text: $text)
                        .padding()
                }
                
                // Button to toggle password visibility
                Button(action: {
                    isPasswordVisible.toggle()
                }) {
                    Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
            }
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
            .cornerRadius(8)
            .frame(height: 44)
            
            // Display error message if any
            if let error = error {
                Text(error)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
    }
}
