//
//  DashboardView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-12.
//

import SwiftUI
import Firebase

struct DashboardView: View {
    
    @State var showLogout = false;
    @EnvironmentObject var userData: UserData
    
    @State var showAlert = false
    @State var messageBody = ""
    @State var messageTitle = ""
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                }
                .frame(minHeight: geometry.size.height)
            }
            .frame(maxWidth: .infinity)
            .navigationBarTitle("Dashboard", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .primaryAction) {
                    Button {
                        showLogout = true
                    } label: {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                    }
                    .tint(.green)
                    .confirmationDialog("Change background", isPresented: $showLogout) {
                        Button("Log Out", role: .destructive) {
                            do {
                                try Auth.auth().signOut()
                            } catch let signOutError as NSError {
                                print("Error signing out: %@", signOutError)
                            }
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text("Are you sure to log out?")
                    }
                }
            }
            .onAppear {
                if let firstLogin = userData.isFirstLogin {
                    if (firstLogin) {
                        messageTitle = "Welcome"
                        messageBody = "Welcome to Expensa. Start your journey by creating a budget."
                    } else {
                        messageTitle = "Welcome Back!"
                        messageBody = "Welcome back to Expensa. Don't forget to add your daily expenses."
                    }
                    DispatchQueue.main.async {
                        showAlert = true 
                    }
                }
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text(messageTitle), message: Text(messageBody), dismissButton: .default(Text("Let's GO!")))
            }
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
