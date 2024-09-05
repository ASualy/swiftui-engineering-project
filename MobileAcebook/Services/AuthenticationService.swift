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
    
//    class PostViewModel: ObservableObject {
//    
//    @Published var posts: [Post] = [] // array to store post objects
//      
//        func fetchPosts() {
//        let urlString = "http://localhost:3000/posts"
//        guard let url = URL(string: urlString) else {
//          print("Invalid URL")
//          return
//        } // will create a url object and if it fails it will print a message and exit the function. guard let is a safety check that checks if a url is valid before continuing
//        // Create a URL request
//        var request = URLRequest(url: url) // creates the url object to present the network request we're going to make
//        request.httpMethod = "GET" // We're fetching data, so we use GET
//        // Create a task to fetch the data
//        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in // creates a networking task and the {()} will be called when the network request goes through with data containing what we receive
//          // Check for errors
//          if let error = error {
//            print("Error fetching data: \(error.localizedDescription)")
//            return
//          }
//          // check that we have some data
//          guard let data = data else {
//            print("No data received")
//            return
//          }
//          do { // do catch block
//            // Create a JSON decoder object
//            let decoder = JSONDecoder()
//            // Decode the data into an array of Post objects
//            let decodedPosts = try decoder.decode([Post].self, from: data)
//            // Update our posts array on the main thread so we can update ui properties
//            DispatchQueue.main.async {
//              self.posts = decodedPosts
//            }
//          } catch {
//            print("Error decoding JSON: \(error.localizedDescription)")
//          }
//        }
//        // Start the task
//        task.resume()
//      }
//    }
    func fetchPosts(completion: @escaping (Result<[Post], Error>) -> Void) {
            let backendURL = ProcessInfo.processInfo.environment["BACKEND_URL"]!
//            let backendURL = ProcessInfo.processInfo.environment["http://localhost:3000/posts"!
            let urlString = "\(backendURL)/posts"

            guard let url = URL(string: urlString) else {
                completion(.failure(URLError(.badURL)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                guard let data = data else {
                    completion(.failure(URLError(.badServerResponse)))
                    return
                }

                do {
                    let posts = try JSONDecoder().decode([Post].self, from: data)
                    completion(.success(posts))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
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
