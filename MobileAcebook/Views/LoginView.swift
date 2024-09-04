//
//  LoginView.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 03/09/2024.
//

import SwiftUI

struct LoginView:View {
    @State var email = ""
    @State var password = ""
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
                
                Button("Login") {
                    //                 login()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5.0)
                .accessibilityIdentifier("registerButton")
                
                NavigationLink("Don't have an account? Please register.", destination: RegistrationView())
                    .padding()
                
                Spacer()
            }
        }
    }


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
