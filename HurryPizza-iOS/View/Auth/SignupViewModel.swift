//
//  SignupViewModel.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import Combine
import SwiftKeychainWrapper

final class SignupViewModel: ObservableObject {
    private let authManager = AuthManager()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isSignupSuccess = false
    
    func signup(email: String, password: String, colorCode: String) {
        authManager.signup(email: email, password: password, colorCode: colorCode)
            .sink(
                receiveCompletion: { print($0) },
                receiveValue: { [weak self] response in
                    guard let self = self else { return }
                    switch response.result {
                    case .success:
                        if let token = response.response?.headers.value(for: "Authorization") {
                            KeychainWrapper.standard.set(token, forKey: "accessToken")
                            self.isSignupSuccess = true
                        }
                    case .failure(let error):
                        print("회원가입 실패: \(error)")
                        self.isSignupSuccess = false
                    }
                }
            ).store(in: &subscriptions)
    }
}
