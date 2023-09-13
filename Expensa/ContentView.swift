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
        NavigationView {
            if (userData.email != nil && userData.email?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                DashboardView()
            } else {
                LoginView()
            }
        }
        .environmentObject(userData)
        .onAppear {
            authStateListenerHandle = Auth.auth().addStateDidChangeListener() { (_, user) in
                if user != nil {
                    userData.email = user?.email
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
