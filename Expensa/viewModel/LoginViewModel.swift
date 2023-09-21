//
//  LoginViewController.swift
//  Expensa
//
//  Created by Minoli Fernando on 2023-09-19.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    
    @Published var loginSheetVisible = false
    @Published var signupSheetVisible = false
    
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    @Published var usernameBorder: Color = .gray
    @Published var passwordBorder: Color = .gray
    @Published var confirmPasswordBorder: Color = .gray
    
    @Published var showAlert = false
    @Published var messageBody = ""
    @Published var messageTitle = ""
    
}
