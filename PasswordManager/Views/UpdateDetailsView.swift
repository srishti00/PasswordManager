//
//  UpdateDetailsView.swift
//  PasswordManager
//
//  Created by srisshar on 02/08/24.
//

import SwiftUI

struct UpdateDetailsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) private var dismiss

    @State var accountType: String
    @State var username: String
    @State var passwordText: String
    @State private var isPasswordVisible: Bool = false

    var password: PasswordEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Edit Account")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.blue)
                .padding()
            
            VStack(alignment: .leading, spacing: 15) {
                // Text fields for editing account details
                CustomTextField(placeholder: "Account Name", text: $accountType, error: .constant(nil))
                CustomTextField(placeholder: "Email", text: $username, error: .constant(nil))
                CustomSecureField(placeholder: "Password", text: $passwordText, isPasswordVisible: $isPasswordVisible, error: .constant(nil))
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 16) {
                // Save button to apply changes
                Button(action: {
                    saveChanges()
                }) {
                    Text("Save")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }
                
                // Cancel button to dismiss the view without saving
                Button(action: {
                    dismiss()
                }) {
                    Text("Cancel")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            Spacer()
        }
        .padding([.top, .leading], 20)
        .onAppear {
            // Populate fields with existing password data when the sheet appears
            accountType = password.accountType ?? ""
            username = password.username ?? ""
            if let encryptedPassword = password.password,
               let decryptedPassword = EncryptionHelper.decrypt(encryptedPassword) {
                passwordText = decryptedPassword
            }
        }
    }
    
    // Function to save changes to the password entity
    private func saveChanges() {
        password.accountType = accountType
        password.username = username
        if let encryptedPassword = EncryptionHelper.encrypt(passwordText) {
            password.password = encryptedPassword
        }
        do {
            try viewContext.save()
            dismiss() // Dismiss the sheet after saving
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}
