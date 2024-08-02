//
//  EditPasswordView.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//

import SwiftUI

struct EditPasswordSheetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) private var presentationMode
    
    @ObservedObject var password: PasswordEntity
    @State private var showEditFormSheet = false // State to control the visibility of the edit form sheet
    @State private var isPasswordVisible = false // Manage password visibility state

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Account Details")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.blue)
                .padding()
            
            VStack(alignment: .leading, spacing: 30) {
                // Display account type, email, and password details
                LabelWithDetail(
                    label: "Account Type",
                    detail: .constant(password.accountType ?? ""),
                    isPassword: false,
                    isPasswordVisible: .constant(true)
                )
                LabelWithDetail(
                    label: "Email",
                    detail: .constant(password.username ?? ""),
                    isPassword: false,
                    isPasswordVisible: .constant(true)
                )
                LabelWithDetail(
                    label: "Password",
                    detail: .constant(getDecryptedPassword()),  // Display decrypted password
                    isPassword: true,
                    isPasswordVisible: $isPasswordVisible // Bind password visibility state
                )
            }
            .padding(.horizontal, 16)
            
            HStack(spacing: 16) {
                // Button to show the edit form sheet
                Button(action: {
                    showEditFormSheet.toggle()
                }) {
                    Text("Edit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(Color("ButtonColor"))
                        .cornerRadius(20)
                }
                
                // Button to delete the password entry and dismiss the view
                Button(action: {
                    deletePassword()
                    presentationMode.wrappedValue.dismiss() // Dismiss the sheet after deletion
                }) {
                    Text("Delete")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            
            Spacer()
        }
        .padding([.top, .leading], 20)
        .sheet(isPresented: $showEditFormSheet) {
            // Present the edit password form sheet
            UpdateDetailsView(
                accountType: password.accountType ?? "",
                username: password.username ?? "",
                passwordText: getDecryptedPassword(),  // Pass decrypted password to the form sheet
                password: password
            )
            .environment(\.managedObjectContext, viewContext)
            .presentationDetents([.medium, .large])
        }
    }
    
    // Function to get the decrypted password
    private func getDecryptedPassword() -> String {
        guard let encryptedPassword = password.password,
              let decryptedPassword = EncryptionHelper.decrypt(encryptedPassword) else {
            return ""
        }
        return decryptedPassword
    }
    
    // Function to delete the password entry from Core Data
    private func deletePassword() {
        viewContext.delete(password)
        do {
            try viewContext.save()
        } catch {
            // Handle error if saving fails
        }
    }
}

struct LabelWithDetail: View {
    var label: String
    @Binding var detail: String
    var isPassword: Bool = false
    @Binding var isPasswordVisible: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .foregroundColor(.gray)
                .font(.subheadline)
            HStack {
                // Display the detail text, masking it if it's a password and visibility is off
                Text(isPassword ? (isPasswordVisible ? detail : String(repeating: "*", count: detail.count)) : detail)
                    .font(.body)
                    .fontWeight(.bold)
                    .padding(.bottom, 2)
                Spacer()
                // Button to toggle password visibility
                if isPassword {
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(Color("Eye"))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
