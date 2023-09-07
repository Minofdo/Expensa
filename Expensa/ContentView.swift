//
//  ContentView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-02.
//

import SwiftUI

struct ContentView: View {
    
    @State private var loginSheetVisible = false
    @State private var signupSheetVisible = true
    
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
                            .presentationDetents([.medium])
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
                            .presentationDetents([.medium])
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
    
    @State var username: String = ""
    @State var password: String = ""
    
    @State var usernameBorder: Color = .gray
    @State var passwordBorder: Color = .gray
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Login to an existing account")
                .font(.title2)
            
            Spacer()
            
            TextField("", text: $username, prompt: Text("Email").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(usernameBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            
            SecureField("", text: $password, prompt: Text("Password").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(passwordBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .padding(.top, 1)
            
            Spacer()
            
            Button(
                action: {
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
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
            Button(
                action: {
                },
                label: {
                    Text("cancel")
                        .font(.title2)
                        .padding(.vertical, 5)
                }
            )
            .padding(.horizontal, 100)
            .buttonStyle(.plain)
            .foregroundColor(.blue)
            .padding(.bottom, 5)
        }
    }
}

struct SignupSheet: View {
    @State var username: String = ""
    @State var password: String = ""
    @State var confirmPassword: String = ""
    
    @State var usernameBorder: Color = .gray
    @State var passwordBorder: Color = .gray
    @State var confirmPasswordBorder: Color = .gray
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Create a new account")
                .font(.title2)
            
            Spacer()
            
            TextField("", text: $username, prompt: Text("Email").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(usernameBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            
            SecureField("", text: $password, prompt: Text("Password").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(passwordBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .padding(.top, 1)
            
            SecureField("", text: $confirmPassword, prompt: Text("Confirm Password").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(confirmPasswordBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .padding(.top, 1)
            
            Spacer()
            
            Button(
                action: {
                    usernameBorder = .gray
                    passwordBorder = .gray
                    confirmPasswordBorder = .gray
                    username = username.trimmingCharacters(in: .whitespacesAndNewlines)
                    password = password.trimmingCharacters(in: .whitespacesAndNewlines)
                    confirmPassword = confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if (username == "") {
                        usernameBorder = .red
                    } else {
                        let emailFormat = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
                        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                        let valid = emailPredicate.evaluate(with: username)
                        if (!valid) {
                            usernameBorder = .red
                        }
                    }
                    if (password == "") {
                        passwordBorder = .red
                    }
                    if (confirmPassword == "") {
                        confirmPasswordBorder = .red
                    }
                },
                label: {
                    Text("SIGNUP")
                        .font(.title2)
                        .padding(.vertical, 5)
                        .frame(maxWidth: .infinity)
                        .bold()
                }
            )
            .padding(.horizontal, 100)
            .buttonStyle(.borderedProminent)
            .tint(.green)
            
            Button(
                action: {
                },
                label: {
                    Text("cancel")
                        .font(.title2)
                        .padding(.vertical, 5)
                }
            )
            .padding(.horizontal, 100)
            .buttonStyle(.plain)
            .foregroundColor(.blue)
            .padding(.bottom, 5)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
