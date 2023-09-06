//
//  ContentView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-02.
//

import SwiftUI

struct ContentView: View {
    
    @State private var loginSheetVisible = false
    @State private var signupSheetVisible = false
    
    var body: some View {
        // https://stackoverflow.com/a/60374737
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image("Expensa")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 150)
                        .foregroundColor(.primary)
                        .shadow(color: .green, radius: 2, x: 0, y: 0)
                        .padding(.top, 10)
                    
                    Text("Your Expense Tracker")
                        .font(.title2)
                        .padding(.top, 15)
                        .padding(.bottom, 2)
                    
                    Text("Please login or signup to continue")
                        .font(.subheadline)
                        .padding(.bottom, 10)
                    
                    Button(
                        action: {
                            loginSheetVisible.toggle()
                        },
                        label: {
                            Text("LOGIN")
                                .font(.title2)
                                .padding(.vertical, 5)
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    )
                    .padding(.horizontal, 100)
                    .padding(.top, 20)
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .sheet(isPresented: $loginSheetVisible) {
                        LoginSheet()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                    
                    Button(
                        action: {
                            signupSheetVisible.toggle()
                        },
                        label: {
                            Text("SIGN UP")
                                .font(.title2)
                                .padding(.vertical, 5)
                                .frame(maxWidth: .infinity)
                                .bold()
                        }
                    )
                    .padding(.horizontal, 100)
                    .padding(.vertical, 10)
                    .buttonStyle(.bordered)
                    .tint(.green)
                    .sheet(isPresented: $signupSheetVisible) {
                        SignupSheet()
                            .presentationDetents([.large])
                            .presentationDragIndicator(.visible)
                    }
                }
                .frame(minHeight: geometry.size.height)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct LoginSheet: View {
    var body: some View {
        Button("Press to dismiss") {
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}

struct SignupSheet: View {
    var body: some View {
        Button("Press to dismiss") {
        }
        .font(.title)
        .padding()
        .background(.black)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
