//
//  FeedService.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 05/09/2024.
//

import Foundation

class FeedService {
    let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"] ?? "http://localhost:3000"

    private let tokenManager = TokenManager()

    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
        guard let url = URL(string: "\(backendURL)/posts") else {
            completion(.failure(NSError(domain: "Invalid URL", code: -1, userInfo: nil)))
            return
        }

        
        let token:String = self.tokenManager.getToken()!
        
//        let token: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiNjZkOTgwMmJhZWU3YTg4ZmMyYzI4ZDAwIiwiaWF0IjoxNzI1NTczNzE0LCJleHAiOjE3MjU1NzQzMTR9.djl7sTiijOjw0A2rQ4UJHbfLju4gMQI68BbY3p5n1To"

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: -1, userInfo: nil)))
                return
            }

            if let responseString = String(data: data, encoding: .utf8) {
                print("Response String: \(responseString)")
            }

            do {
                let postsResponse = try JSONDecoder().decode(PostsResponse.self, from: data)
                print("Decoded posts: \(postsResponse.posts)")
                completion(.success(postsResponse.posts))
            } catch {
                print("Failed to decode posts: \(error)")
                completion(.failure(error))
            }
        }.resume()
    }
}

struct PostsResponse: Decodable {
    let posts: [Post]
}
