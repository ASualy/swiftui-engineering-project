//
//  AuthenticationService.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation

class AuthenticationService: AuthenticationServiceProtocol {
    
    func signUp(user: User, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"]!
        // print("BackendURL: \(String(describing: backendURL))")
        
        guard let url = URL(string: "\(backendURL)/users") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        // Prepare the request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Convert user object to JSON
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            completion(.failure(error))
            return
        }
        
        // Make the network request
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            if (httpResponse.statusCode==201) {
                completion(.success(true))
            } else if (httpResponse.statusCode==400) {
                let errorCode = URLError(.badServerResponse).errorCode
                if (errorCode == -1011) {
                    //                    print ("Got ya!")
                    let customError = CustomError.message("This email is already registered, please use another one.")
                    completion(.failure(customError))
                }else{
                    completion(.failure(URLError(.badServerResponse)))
                }
                return
            }
            
            // Process the response
            guard data != nil else {
                completion(.failure(URLError(.cannotDecodeContentData)))
                return
            }
            
            // Indicating success
            completion(.success(true))
        }
        
        task.resume()
    }
    
    @Published var isLoggedIn: Bool = false
    
    func logIn(user: User, completion: @escaping (Bool) -> Void) {
        let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"]!
        
        guard let url = URL(string: "\(backendURL)/tokens") else {
            print("Invalid URL")
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let userData = ["email": user.email, "password": user.password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: userData)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Invalid response")
                completion(false)
                return
            }
            
            print("HTTP Status Code: \(httpResponse.statusCode)")
            
            guard let data = data else {
                print("No data received")
                completion(false)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Received JSON: \(json)")
                    
                    if httpResponse.statusCode == 201 {
                        if let token = json["token"] as? String,
                           let userId = json["user_id"] as? String {
                            self.storeUserId(userId: userId)
                            self.storeToken(token: token)
                            
                            DispatchQueue.main.async {
                                self.isLoggedIn = true
                            }
                            completion(true)
                            print("Login successful. User ID: \(userId), Token: \(token)")
                        } else {
                            print("Missing token or user_id in response")
                            completion(false)
                        }
                    } else {
                        if let message = json["message"] as? String {
                            print("Login failed: \(message)")
                        } else {
                            print("Login failed with unknown error")
                        }
                        completion(false)
                    }
                } else {
                    print("Invalid JSON format")
                    completion(false)
                }
            } catch {
                print("Error parsing response: \(error)")
                completion(false)
            }
        }
        task.resume()
    }
    
    // Store the user ID in UserDefaults
    private func storeUserId(userId: String) {
        UserDefaults.standard.set(userId, forKey: "userId")
    }
    
    // Store the token in UserDefaults
    private func storeToken(token: String) {
        UserDefaults.standard.set(token, forKey: "authToken")
    }
    
    // Implement the getUserId method
    func getUserId() -> String? {
        return UserDefaults.standard.string(forKey: "userId")
    }
    
    // Implement the getToken method
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
}

enum CustomError: Error {
    case message(String)
    
    var localizedDescription: String {
        switch self {
        case .message(let msg):
            return msg
        }
    }
}
