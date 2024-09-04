//
//  AuthenticationService.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

import Foundation

class AuthenticationService: AuthenticationServiceProtocol {
    
    @Published var isLoggedIn: Bool = false
    
    func signUp(user: User) -> Bool {
        // Logic to call the backend API for signing up
        return true // placeholder
    }
    
    func logIn(user: User, completion: @escaping (Bool) -> Void) {
        // completion handler thats called with a boolean to show if it was successful or not. anytime theres an error that doesn't lead to logging in completion(false) is called
        let urlString = "http://localhost:3000/tokens"
        guard let url = URL(string: urlString) else {
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
                print("Error logging in at creating task - \(error.localizedDescription)")
                completion(false)
                return
            }
            
            // checks to see if response is 201 (same as backend). if it is, isloggedin is set to true and completion(true)
            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 {
                DispatchQueue.main.async {
                    self.isLoggedIn = true
                }
                completion(true)
                print("logged in")
            } else {
                completion(false)
                print("Unable to login at http response bit")
            }
        }
        task.resume()
    }
}
