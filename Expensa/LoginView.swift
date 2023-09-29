//
//  LoginView.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-10.
//

import SwiftUI
import Firebase

struct LoginView: View {
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
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
                            loginViewModel.loginSheetVisible.toggle()
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
                    .sheet(isPresented: $loginViewModel.loginSheetVisible) {
                        LoginSheet()
                            .presentationDetents([.medium])
                            .presentationDragIndicator(.visible)
                    }
                    
                    Button(
                        action: {
                            loginViewModel.signupSheetVisible.toggle()
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
                    .sheet(isPresented: $loginViewModel.signupSheetVisible) {
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
    
    @EnvironmentObject var userData: UserData
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Login to an existing account")
                .font(.title2)
            
            Spacer()
            
            TextField("", text: $loginViewModel.username, prompt: Text("Email").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(loginViewModel.usernameBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            
            SecureField("", text: $loginViewModel.password, prompt: Text("Password").foregroundColor(.primary)
            )
            .textContentType(.oneTimeCode)
            .textFieldStyle(.plain)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(loginViewModel.passwordBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .padding(.top, 1)
            
            Spacer()
            
            Button(
                action: {
                    loginViewModel.usernameBorder = .gray
                    loginViewModel.passwordBorder = .gray
                    loginViewModel.username = loginViewModel.username.trimmingCharacters(in: .whitespacesAndNewlines)
                    loginViewModel.password = loginViewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if (loginViewModel.username == "") {
                        loginViewModel.usernameBorder = .red
                    } else {
                        let emailFormat = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
                        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                        let valid = emailPredicate.evaluate(with: loginViewModel.username)
                        if (!valid) {
                            loginViewModel.usernameBorder = .red
                            loginViewModel.messageTitle = "Invalid Email"
                            loginViewModel.messageBody = "Email format is invalid. Please check and try again."
                            loginViewModel.showAlert = true
                        }
                    }
                    if (loginViewModel.password == "") {
                        loginViewModel.passwordBorder = .red
                    }
                    if (loginViewModel.usernameBorder != .red && loginViewModel.passwordBorder != .red) {
                        Auth.auth().signIn(withEmail: loginViewModel.username, password: loginViewModel.password) { (_, error) in
                            if let error = error {
                                if (error._code == 17009 || error._code == 17011) {
                                    loginViewModel.messageTitle = "ERROR"
                                    loginViewModel.messageBody = "Username or Password is incorrect. Please try again."
                                    loginViewModel.showAlert = true;
                                } else {
                                    loginViewModel.messageTitle = "ERROR"
                                    loginViewModel.messageBody = error.localizedDescription
                                    loginViewModel.showAlert = true;
                                }
                            } else {
                                userData.isFirstLogin = false;
                                dismiss()
                            }
                        }
                    }
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
            .alert(isPresented: $loginViewModel.showAlert) {
                Alert(title: Text(loginViewModel.messageTitle), message: Text(loginViewModel.messageBody), dismissButton: .default(Text("OK")))
            }
            
            Button(
                action: {
                    dismiss()
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
    
    @EnvironmentObject var userData: UserData
    
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var loginViewModel = LoginViewModel()
    
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Create a new account")
                .font(.title2)
            
            Spacer()
            
            TextField("", text: $loginViewModel.username, prompt: Text("Email").foregroundColor(.primary)
            )
            .textFieldStyle(.plain)
            .keyboardType(.emailAddress)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(loginViewModel.usernameBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            
            SecureField("", text: $loginViewModel.password, prompt: Text("Password").foregroundColor(.primary)
            )
            .textContentType(.oneTimeCode)
            .textFieldStyle(.plain)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(loginViewModel.passwordBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .padding(.top, 1)
            
            SecureField("", text: $loginViewModel.confirmPassword, prompt: Text("Confirm Password").foregroundColor(.primary)
            )
            .textContentType(.oneTimeCode)
            .textFieldStyle(.plain)
            .padding()
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(loginViewModel.confirmPasswordBorder, lineWidth: 1)
            )
            .padding(.horizontal, 30)
            .padding(.top, 1)
            
            Spacer()
            
            Button(
                action: {
                    loginViewModel.usernameBorder = .gray
                    loginViewModel.passwordBorder = .gray
                    loginViewModel.confirmPasswordBorder = .gray
                    loginViewModel.username = loginViewModel.username.trimmingCharacters(in: .whitespacesAndNewlines)
                    loginViewModel.password = loginViewModel.password.trimmingCharacters(in: .whitespacesAndNewlines)
                    loginViewModel.confirmPassword = loginViewModel.confirmPassword.trimmingCharacters(in: .whitespacesAndNewlines)
                    
                    if (loginViewModel.username == "") {
                        loginViewModel.usernameBorder = .red
                    } else {
                        let emailFormat = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
                        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
                        let valid = emailPredicate.evaluate(with: loginViewModel.username)
                        if (!valid) {
                            loginViewModel.usernameBorder = .red
                            loginViewModel.messageTitle = "Invalid Email"
                            loginViewModel.messageBody = "Email format is invalid. Please check and try again."
                            loginViewModel.showAlert = true
                        }
                    }
                    if (loginViewModel.password == "") {
                        loginViewModel.passwordBorder = .red
                    }
                    if (loginViewModel.confirmPassword == "") {
                        loginViewModel.confirmPasswordBorder = .red
                    }
                    if (loginViewModel.password != "" && loginViewModel.password != loginViewModel.confirmPassword) {
                        loginViewModel.passwordBorder = .red
                        loginViewModel.confirmPasswordBorder = .red
                        loginViewModel.messageTitle = "Password Mismatch"
                        loginViewModel.messageBody = "Password and Confirm Password fields doesn't match. Please renter both passwords and try again."
                        loginViewModel.showAlert = true
                    }
                    if (loginViewModel.usernameBorder != .red && loginViewModel.passwordBorder != .red && loginViewModel.confirmPasswordBorder != .red) {
                        Auth.auth().createUser(withEmail: loginViewModel.username, password: loginViewModel.password) { (_, error) in
                            if let error = error {
                                if (error._code == 17007) {
                                    loginViewModel.messageTitle = "ERROR"
                                    loginViewModel.messageBody = "Account already exist. Please login."
                                    loginViewModel.showAlert = true;
                                } else {
                                    loginViewModel.messageTitle = "ERROR"
                                    loginViewModel.messageBody = error.localizedDescription
                                    loginViewModel.showAlert = true;
                                }
                            } else {
                                userData.isFirstLogin = true;
                                dismiss()
                            }
                        }
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
            .alert(isPresented: $loginViewModel.showAlert) {
                Alert(title: Text(loginViewModel.messageTitle), message: Text(loginViewModel.messageBody), dismissButton: .default(Text("OK")))
            }
            
            Button(
                action: {
                    dismiss()
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
