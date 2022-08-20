//
//  AuthResponse.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

struct AuthResponse: Response {
    var message: String?
    /// jwt
    var data: String?
}
