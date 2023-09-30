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
    @State var isLoadingData = false
    @State var initialLoad = true
    @StateObject var userData = UserData()
    
    var body: some View {
        // https://roddy.io/2020/07/27/create-progressview-modal-in-swiftui/
        NavigationView {
            if initialLoad {
                SplashView()
            } else if (userData.email != nil && userData.email?.trimmingCharacters(in: .whitespacesAndNewlines) != "") {
                DashboardView()
            } else {
                LoginView()
                    .overlay(
                        isLoadingData ? LoadingView() : nil
                    )
            }
        }
        .environmentObject(userData)
        .onAppear {
            authStateListenerHandle = Auth.auth().addStateDidChangeListener() { (_, user) in
                if let email = user?.email {
                    Task {
                        do {
                            isLoadingData = true
                            let _ = try await userData.loadDataForUser(email)
                            isLoadingData = false
                            userData.email = email
                        } catch {
                            print(error)
                            isLoadingData = false
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            initialLoad = false
                        }
                    }
                } else {
                    userData.email = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        initialLoad = false
                    }
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
