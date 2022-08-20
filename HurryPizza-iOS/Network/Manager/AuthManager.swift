//
//  AuthManager.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import Alamofire
import Combine
import SwiftKeychainWrapper

final class AuthManager {
    static let shared = AuthManager()
    
    var isAuthenticated: Bool {
        let token = KeychainWrapper.standard.string(forKey: "accessToken")
        return token != nil && !token!.isEmpty
    }
    
    func verifyToken() -> AnyPublisher<DataResponse<AuthResponse, AuthError>, Never> {
        let url = URL(string: "http://3.37.56.182:8080/v1/users/auth/validate")!
        guard let token = KeychainWrapper.standard.string(forKey: "accessToken") else {
            KeychainWrapper.standard.remove(forKey: "accessToken")
            return Empty().eraseToAnyPublisher()
        }
        
        var request = try? URLRequest(url: url, method: .post)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.setValue(token, forHTTPHeaderField: "Authorization")
        
        guard let request = request else {
            KeychainWrapper.standard.remove(forKey: "accessToken")
            return Empty().eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate()
            .publishDecodable(type: AuthResponse.self)
            .map { response in
                response.mapError { error in
                    print(error)
                    KeychainWrapper.standard.remove(forKey: "accessToken")
                    return AuthError.verifyTokenError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func signup(
        email: String,
        nickname: String,
        password: String,
        colorCode: String
    ) -> AnyPublisher<DataResponse<AuthResponse, AuthError>, Never> {
        let url = URL(string: "http://3.37.56.182:8080/v1/users/auth")!
        
        var request = try? URLRequest(url: url, method: .post)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: String] = [
            "email": email,
            "nickname": nickname,
            "password": password,
            "color": colorCode
        ]

        try? request?.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        
        guard let request = request else {
            return Empty().eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate()
            .publishDecodable(type: AuthResponse.self)
            .map { response in
                response.mapError { error in
                    print(error)
                    return AuthError.signupError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func signin(
        email: String,
        password: String
    ) -> AnyPublisher<DataResponse<AuthResponse, AuthError>, Never> {
        let url = URL(string: "http://3.37.56.182:8080/v1/users/auth/login")!
        
        var request = try? URLRequest(url: url, method: .post)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: String] = [
            "email": email,
            "password": password
        ]
        try? request?.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        
        guard let request = request else {
            return Empty().eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate()
            .publishDecodable(type: AuthResponse.self)
            .map { response in
                response.mapError { error in
                    print(error)
                    return AuthError.signinError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum AuthError: Error {
    case signupError
    case signinError
    case verifyTokenError
}
