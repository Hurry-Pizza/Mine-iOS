//
//  SigninViewModel.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import Combine
import SwiftKeychainWrapper

final class SigninViewModel: ObservableObject {
    private let authManager = AuthManager()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isSignInSuccess = false
    
    func signin(email: String, password: String) {
        authManager.signin(email: email, password: password)
            .sink(
                receiveCompletion: { print($0) },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success:
                        if let token = response.response?.headers.value(for: "Authorization") {
                            KeychainWrapper.standard.set(token, forKey: "accessToken")
                            print(token)
                            self.isSignInSuccess = true
                        }
                    case .failure(let error):
                        print("로그인 실패: \(error)")
                        self.isSignInSuccess = false
                    }
                }
            ).store(in: &subscriptions)
    }
}
