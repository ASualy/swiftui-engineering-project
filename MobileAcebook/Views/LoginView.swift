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
    
    // creating instance of authenticationservice based off the protocol
    private let authService: AuthenticationServiceProtocol
    
    // initialiser changed to help pass correct parameter test
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
                    //                 login()
                    loginAction()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5.0)
                .accessibilityIdentifier("registerButton")
                
                Text(loginMessage)
                    .padding()
                    .foregroundColor(loginMessage == "Login Successful" ? .green : .red)
                
                NavigationLink("Don't have an account? Please register.", destination: RegistrationView())
                    .padding()
                
                Spacer()
            }
        }

    
    // creates a user object with the entered email and password, calls the login method in the authentication service and updates the loginmessage
    func loginAction() {
            let user = User(email: email, password: password)
            authService.logIn(user: user) { success in
                DispatchQueue.main.async {
                    self.loginMessage = success ? "Login Successful" : "Login Failed"
                    print("Login message updated: \(self.loginMessage)")
                }
            }
        }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
