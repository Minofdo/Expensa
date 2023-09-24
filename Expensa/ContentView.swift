//
//  ContentView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-02.
//

import SwiftUI
import Firebase

struct ContentView: View {
    
    @State var authStateListenerHandle: AuthStateDidChangeListenerHandle?
    @StateObject var userData = UserData()
    
    var body: some View {
        // https://roddy.io/2020/07/27/create-progressview-modal-in-swiftui/
        NavigationView {
            if (userData.email != nil && userData.email?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                DashboardView()
            } else {
                LoginView()
                    .overlay(
                        userData.isLoadingData ? LoadingView() : nil
                    )
            }
        }
        .environmentObject(userData)
        .onAppear {
            authStateListenerHandle = Auth.auth().addStateDidChangeListener() { (_, user) in
                if let email = user?.email {
                    Task {
                        do {
                            userData.isLoadingData = true
                            try await userData.loadDataForUser(email)
                            userData.isLoadingData = false
                            userData.email = email
                        } catch {
                            userData.isLoadingData = false
                        }
                    }
                } else {
                    userData.email = nil
                }
            }
        }
        .onDisappear {
            if let handle = authStateListenerHandle {
                Auth.auth().removeStateDidChangeListener(handle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
