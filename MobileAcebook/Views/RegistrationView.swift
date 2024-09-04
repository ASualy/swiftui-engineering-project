//
//  RegistrationView.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 02/09/2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var username: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
            VStack {
                Text("Acebook Mobile")
                    .padding(50)
                    .font(.largeTitle)
                    .padding(.bottom, 20)
                

                Text("Full name:")
                    .padding(.leading, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Username", text: $username)
                    .padding()
                    .frame(width: 350)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .accessibilityIdentifier("usernameTextField")
                
                Text("Email:")
                    .padding(.leading,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("Email", text: $email)
                    .padding()
                    .frame(width: 350)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .keyboardType(.emailAddress)
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
                
                Text("Confirm password:")
                    .padding(.leading,20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .frame(width: 350)
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(5.0)
                    .accessibilityIdentifier("confirmPasswordTextField")
                

                VStack(spacing: 15) {
                    
                    Text("Full name:")
                        .padding(.leading, 20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Username", text: $username)
                        .padding()
                        .frame(width: 350)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .accessibilityIdentifier("usernameTextField")
                    
                    Text("Email:")
                        .padding(.leading,20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    TextField("Email", text: $email)
                        .padding()
                        .frame(width: 350)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .keyboardType(.emailAddress)
                        .accessibilityIdentifier("emailTextField")
                    
                    Text("Password:")
                        .padding(.leading,20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SecureField("Password", text: $password)
                        .padding()
                        .frame(width: 350)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .accessibilityIdentifier("passwordTextField")
                    
                    Text("Confirm password:")
                        .padding(.leading,20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .frame(width: 350)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(5.0)
                        .accessibilityIdentifier("confirmPasswordTextField")
                }

                Button("Register") {
                    register()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5.0)
                .accessibilityIdentifier("registerButton")
                
                NavigationLink("Already have an account? Please login.", destination: LoginView())
                    .padding()
                
                Spacer()
                
            }
            
            .padding()
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Registration"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
            
        }
    
    private func register() {
            // Ensure fields are not empty
            guard !username.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
                alertMessage = "Please fill in all fields."
                showingAlert = true
                return
            }
            
            // Ensure passwords are match
            guard password == confirmPassword else {
                alertMessage = "Passwords do not match."
                showingAlert = true
                return
            }
            
        
            let authService = AuthenticationService()
            let user = User(email: email, username: username, password: password)

                authService.signUp(user: user) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            alertMessage = "Registration successful!"
                        case .failure(let error):
                            if let customError = error as? CustomError {
                                alertMessage = "Failed to sign up:\(customError.localizedDescription)"
                            }else{
                                alertMessage = "Failed to sign up: \(error.localizedDescription)"
                            }
                        }
                        showingAlert = true
                    }
                }
            }
        }



struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
