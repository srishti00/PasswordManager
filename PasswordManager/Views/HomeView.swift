//
//  HomeView.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \PasswordEntity.accountType, ascending: true)],
        animation: .default
    ) private var passwords: FetchedResults<PasswordEntity>
    
    @State private var isShowingAddSheet = false // State for showing the Add Password sheet
    @State private var selectedPassword: PasswordEntity? // State for the selected password for editing
    @State private var isShowingEditSheet = false // State for showing the Edit Password sheet
    
    var body: some View {
        NavigationView {
            ZStack {
                // List of passwords
                List {
                    ForEach(passwords) { password in
                        Button(action: {
                            selectedPassword = password
                            isShowingEditSheet.toggle()
                        }) {
                            PasswordListRow(password: password)
                        }
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .toolbar {
                    // Custom toolbar with title
                    ToolbarItem(placement: .topBarLeading) {
                        Text("Password Manager")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(.primary)
                    }
                }
                .toolbarBackground(.visible, for: .navigationBar)
                
                // Floating button to add a new password
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button(action: {
                            isShowingAddSheet.toggle()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.blue)
                                    .frame(width: 60, height: 60)
                                Image(systemName: "plus")
                                    .foregroundColor(.white)
                                    .font(.system(size: 30, weight: .bold))
                            }
                            .shadow(radius: 10)
                        }
                        .padding()
                        .sheet(isPresented: $isShowingAddSheet) {
                            AddPasswordSheetView()
                                .environment(\.managedObjectContext, viewContext)
                                .presentationDetents([.medium, .large]) // Sheet size options
                        }
                        .sheet(item: $selectedPassword) { password in
                            EditPasswordSheetView(password: password)
                                .environment(\.managedObjectContext, viewContext)
                                .presentationDetents([.medium, .large]) // Sheet size options
                        }
                    }
                }
            }
        }
    }
}

struct PasswordListRow: View {
    @ObservedObject var password: PasswordEntity
    @State private var isPasswordVisible = false // State to toggle password visibility
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(password.accountType ?? "Unknown")
                        .font(.headline)
                    Text(isPasswordVisible ? decryptedPassword() : maskedPassword())
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 5)
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .padding(.bottom, 20)
    }
    
    // Decrypts the password for display
    private func decryptedPassword() -> String {
        guard let encryptedPassword = password.password else { return "No Password" }
        return EncryptionHelper.decrypt(encryptedPassword) ?? "No Password"
    }
    
    // Masks the password with asterisks
    private func maskedPassword() -> String {
        let passwordCount = password.password?.count ?? 0
        return String(repeating: "*", count: passwordCount)
    }
}
