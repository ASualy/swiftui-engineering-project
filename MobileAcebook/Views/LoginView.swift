//
//  LoginView.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 03/09/2024.
//

import SwiftUI

struct LoginView:View {
    @State private var email = ""
    @State private var password = ""
    @State private var loginMessage: String = ""
    @State private var isLoading: Bool = false
    @EnvironmentObject var userSession: UserSession
    
    private let authService: AuthenticationServiceProtocol
    
    init(email: String = "", password: String = "", authService: AuthenticationServiceProtocol = AuthenticationService()) {
        self._email = State(initialValue: email)
        self._password = State(initialValue: password)
        self.authService = authService
    }
    
    var body: some View {
            VStack {
                Text("Acebook Mobile")
                    .padding(50)
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                
                Text("Email:")
                    .padding(.leading,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 350)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .keyboardType(.default)
                    .accessibilityIdentifier("emailTextField")
                    .textInputAutocapitalization(.never)
                
                Text("Password:")
                    .padding(.leading,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureField("Password", text: $password)
                    .padding()
                    .frame(width: 350)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .accessibilityIdentifier("passwordTextField")
                    .textInputAutocapitalization(.never)
                
                Button("Login") {
                    loginAction()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5.0)
                .accessibilityIdentifier("loginButton")
                .disabled(isLoading)
                
                if isLoading {
                    ProgressView()
                }
                
                Text(loginMessage)
                    .padding()
                    .foregroundColor(loginMessage == "Login Successful" ? .green : .red)
                
                NavigationLink("Don't have an account? Please register.", destination: RegistrationView())
                    .padding()
                
                NavigationLink("Create Post - ONLY FOR NAVIGATING TO TEST CREATE POST. NOT TO BE INCLUDED.", destination: CreatePostView())
                    .padding()
                
                Spacer()
            }
        }

    
    // creates a user object with the entered email and password, calls the login method in the authentication service and updates the loginmessage
    func loginAction() {
            isLoading = true
            loginMessage = ""
            let user = User(email: email, password: password)
            authService.logIn(user: user) { success in
                DispatchQueue.main.async {
                    self.isLoading = false
                    if success {
                        if let userId = self.authService.getUserId() {
                            self.userSession.logIn(userId: userId)
                            self.loginMessage = "Login Successful"
                            print("Login successful for user ID: \(userId)")
                            // Navigate to the next view or update app state here
                        } else {
                            self.loginMessage = "Login Failed: Unable to retrieve user ID"
                            print("Login failed: Unable to retrieve user ID")
                        }
                    } else {
                        self.loginMessage = "Login Failed. Please check your email and password."
                        print("Login failed")
                    }
                }
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
