//
//  AuthManager.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import Alamofire
import Combine

final class AuthManager {
    static let shared = AuthManager()
    
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
                    return AuthError.signupError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

enum AuthError: Error {
    case signupError
}
