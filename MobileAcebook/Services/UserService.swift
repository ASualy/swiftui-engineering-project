//
//  UserService.swift
//  MobileAcebook
//
//  Created by Oleg Novikov on 04/09/2024.
//

import Foundation

class UserService {
    // Function to fetch user details using the JWT token
    func getUserDetails(token: String, completion: @escaping (Result<User, Error>) -> Void) {
        
        let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"]!
        
        guard let url = URL(string: "\(backendURL)/users") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        // Set the Authorization header with the Bearer token
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
                   if let error = error {
                       completion(.failure(error))
                       return
                   }
                   
                   guard let data = data else {
                       completion(.failure(URLError(.badServerResponse)))
                       return
                   }
                   
                   // Print raw data as a string for debugging
                   if let jsonString = String(data: data, encoding: .utf8) {
                       print("Raw JSON response: \(jsonString)")
                   }

                   // Decode the user data from JSON
                   do {
                       let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
                       
                       // Check if userData array contains at least one user
                       if let user = userResponse.userData.first {
                           completion(.success(user))
                       } else {
                           completion(.failure(URLError(.cannotFindHost))) // You can customize the error message
                       }
                       
                   } catch {
                       print("Decoding error: \(error)")
                       completion(.failure(error))
                   }
               }.resume()
           }
       }
