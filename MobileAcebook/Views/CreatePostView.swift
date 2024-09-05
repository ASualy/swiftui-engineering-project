//
//  CreatePostView.swift
//  MobileAcebook
//
//  Created by Abdallah Harun on 05/09/2024.
//

import Foundation
import SwiftUI

struct CreatePostView: View {
    @State private var postContent: String = ""
    @State private var postMessage: String = ""
    @State private var isLoading: Bool = false
    @State private var user: User?

    private let createPostService: CreatePostServiceProtocol
    private let userService = UserService()
    private let tokenManager = TokenManager()

    init(postContent: String = "", createPostService: CreatePostServiceProtocol = CreatePostService()) {
        self._postContent = State(initialValue: postContent)
        self.createPostService = createPostService
        _isLoading = State(initialValue: true)
        fetchUserDetails()
    }

    var body: some View {
        VStack {
            Text("Acebook Mobile")
                .padding(50)
                .font(.largeTitle)
                .padding(.bottom, 20)

            if isLoading {
                        ProgressView("Loading...")
                    } else if let user = user {
                        Text("Welcome, \(user.username ?? "User")")
                        
                        Text("Post Content:")
                            .padding(.leading, 20)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        TextEditor(text: $postContent)
                            .padding()
                            .frame(width: 350, height: 200)
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(5.0)
                            .accessibilityIdentifier("postContentTextEditor")

                        Button("Create Post") {
                            createPostAction()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(5.0)
                        .accessibilityIdentifier("createPostButton")

                        Text(postMessage)
                            .padding()
                            .foregroundColor(postMessage == "Post Created Successfully" ? .green : .red)
                    } else {
                        Text("Error: User details not available")
                            .foregroundColor(.red)
                    }

                    Spacer()
                }
        .onAppear {
                fetchUserDetails()
            }
    }
    
    private func fetchUserDetails() {
        guard let token = tokenManager.getToken() else {
            postMessage = "Error: no token found"
            isLoading = false
            return
        }
        
        isLoading = true
        userService.getUserDetails(token: token) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let user):
                    self.user = user
                    print("User details fetched successfully: \(user)")
                case .failure(let error):
                    self.postMessage = "Error: \(error.localizedDescription)"
                    print("Error fetching user details: \(error)")
                }
            }
        }
    }

    func createPostAction() {
        if user == nil {
            fetchUserDetails()
            return
        }
        
        guard let user = user else {
            self.postMessage = "Error: user details not available"
            print(self.postMessage)
            return
        }

        isLoading = true
        postMessage = ""

        let post = Post(id: UUID().uuidString, username: user.username ?? "", message: postContent, userId: user._id ?? "", imgUrl: user.imgUrl ?? "", likes: [])
        createPostService.createPost(post: post) { success in
            DispatchQueue.main.async {
                self.isLoading = false
                self.postMessage = success ? "Post Created Successfully" : "Post Creation Failed"
                if success {
                    self.postContent = ""
                }

                print(success ? "Post created successfully" : "Unable to create post")
            }
        }
    }
}

struct CreatePostView_Previews: PreviewProvider {
    static var previews: some View {
        CreatePostView()
    }
}
