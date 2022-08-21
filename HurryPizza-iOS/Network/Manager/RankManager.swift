//
//  RankManager.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import Combine
import Alamofire
import SwiftKeychainWrapper

final class RankManager {
    static let shared = RankManager()
    
    func getRanks() -> AnyPublisher<DataResponse<RankResponse, Error>, Never> {
        let url = URL(string: "http://3.37.56.182:8080/v1/ranks")!
        
//        guard let token = KeychainWrapper.standard.string(forKey: "accessToken") else {
//            KeychainWrapper.standard.remove(forKey: "accessToken")
//            return Empty().eraseToAnyPublisher()
//        }
		// swiftlint:disable:next line_length
		let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiIsImtpZCI6ImRlZmF1bHQifQ.eyJzdWIiOiJ1c2VyIiwiaW5mbyI6eyJpZCI6MTgsImVtYWlsIjoibjIyMmV3QGdtYWlsLmNvbSIsInJvbGUiOiJST0xFX1VTRVIifSwiZXhwIjoxNjYzNTg0NjUyfQ.B6E9dX44k9FAfL9dqSmc2aQOy10pnp_kmzOPD6-A8qg"
        
        var request = try? URLRequest(url: url, method: .get)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request?.setValue(token, forHTTPHeaderField: "Authorization")

        guard let request = request else {
            return Empty().eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate()
            .publishDecodable(type: RankResponse.self)
            .map { response in
                response.mapError { error in
                    print(error)
                    return PathError.otherUserPathError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
}
