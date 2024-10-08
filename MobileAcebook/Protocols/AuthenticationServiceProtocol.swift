//
//  AuthenticationServiceProtocol.swift
//  MobileAcebook
//
//  Created by Josué Estévez Fernández on 01/10/2023.
//

public protocol AuthenticationServiceProtocol {
    func signUp(user: User, completion: @escaping (Result<Bool, Error>) -> Void)

    func logIn(user: User, completion: @escaping (Bool) -> Void)
}
