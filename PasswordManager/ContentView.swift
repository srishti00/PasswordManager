//
//  ContentView.swift
//  PasswordManager
//
//  Created by srisshar on 01/08/24.
//
import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthenticationViewModel()

    var body: some View {
        Group {
            if authViewModel.isUnlocked {
                HomeView()
                    .environment(\.managedObjectContext, PersistenceController.shared.container.viewContext)
            } else {
                Text("Authenticating...")
                    .onAppear {
                        authViewModel.authenticate()
                    }
            }
        }
    }
}
