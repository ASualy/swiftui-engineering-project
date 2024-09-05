//
//  CreatePostService.swift
//  MobileAcebook
//
//  Created by Abdallah Harun on 05/09/2024.
//

import Foundation

class CreatePostService: CreatePostServiceProtocol {
    private let tokenManager = TokenManager()
    
    func createPost(post: Post, completion: @escaping (Bool) -> Void) {
        let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"]!
        guard let url = URL(string: "\(backendURL)/posts") else {
            print("Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

//        // Add authorization token to the request header
//        if let token = UserDefaults.standard.string(forKey: "authToken") {
//            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        } else {
//            print("No authorization token found")
//            completion(false)
//            return
//        }
        
        // tokenmanager at work here to get the token
        if let token = tokenManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("No token found")
            completion(false)
            return
        }

        let postData = [
            "message": post.message,
            "imgUrl": post.imgUrl
        ]

        request.httpBody = try? JSONSerialization.data(withJSONObject: postData)

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error creating post - \(error.localizedDescription)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode == 201 {
                    completion(true)
                    print("Post created successfully")
                } else {
                    completion(false)
                    print("Unable to create post. Status code: \(httpResponse.statusCode)")

                    // printing response body for debugging
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response body: \(responseString)")
                    }
                }
            } else {
                completion(false)
                print("Unable to create post. Invalid response.")
            }
        }
        task.resume()
    }
}
