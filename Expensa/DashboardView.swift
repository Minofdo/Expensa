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
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
