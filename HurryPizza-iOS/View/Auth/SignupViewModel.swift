//
//  SignupViewModel.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import SwiftUI
import Combine
import SwiftKeychainWrapper

final class SignupViewModel: ObservableObject {
    private let authManager = AuthManager()
    private var subscriptions = Set<AnyCancellable>()
    
    @Published var isSignupFail = false
    
    let pathColors: [Color] = [.red, .blue, .green, .yellow, .orange, .cyan]
    
    func signup(email: String, nickname: String, password: String) {
        guard let colorCode = pathColors.randomElement()?.toHex() else {
            return
        }
        
        authManager.signup(
            email: email,
            nickname: nickname,
            password: password,
            colorCode: colorCode
        )
        .sink(
            receiveCompletion: { print($0) },
            receiveValue: { [weak self] response in
                guard let self = self else { return }
                switch response.result {
                case .success:
                    if let token = response.response?.headers.value(for: "Authorization") {
                        KeychainWrapper.standard.set(token, forKey: "accessToken")
                        self.isSignupFail = false
                    }
                case .failure(let error):
                    print("회원가입 실패: \(error)")
                    self.isSignupFail = true
                }
            }
        )
        .store(in: &subscriptions)
    }
}
