//
//  ProfileView.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 04/09/2024.
//
import SwiftUI

struct ProfileView: View {
    let token: String?
    @State private var user: User? = nil
    @State private var isLoading = true
    @State private var errorMessage: String? = nil
    
    private let userService = UserService()

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading user profile...")
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
            } else if let user = user {
                VStack {
//                    Text("Welcome, \(user.username ?? "User")")
//                        .padding(50)
//                        .font(.largeTitle)
//                        .padding(.bottom, 20)
                    
                    if let imageUrl = user.imgUrl, !imageUrl.isEmpty {
                        AsyncImage(url: URL(string: imageUrl)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 200, height: 200)
                                .clipShape(Circle())
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.bottom, 20)
                    }
                    
                    HStack {
                        Text("Full name:")
                        Spacer()
                        Text(user.username ?? "N/A")
                    }
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Email:")
                        Spacer()
                        Text(user.email)
                    }
                    .padding(.horizontal)
                }
                
                HStack {
                    Button("Save") {
                        // Save action
                    }
                    .padding()
                    .frame(width: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .accessibilityIdentifier("saveButton")
                    
                    Button("Cancel") {
                        // Cancel action
                    }
                    .padding()
                    .frame(width: 100)
                    .background(Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(5.0)
                    .accessibilityIdentifier("cancelButton")
                }
                .padding(.top, 20)
            }
        }
        .padding()
        .onAppear {
            fetchUserDetails()
        }
    }
    
    private func fetchUserDetails() {
        userService.getUserDetails(token: token!) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self.user = user
                    self.isLoading = false
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        // Copy your active token to generate preview
        ProfileView(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZkOTgwMmJhZWU3YTg4ZmMyYzI4ZDAwIiwiaWF0IjoxNzI1NTYyNDg5LCJleHAiOjE3MjU1NjMwODl9.Qf0p30YASlhpNvxEEGzlPIn6Bi4vC41rtw9yIpIAXHM")
    }
}


