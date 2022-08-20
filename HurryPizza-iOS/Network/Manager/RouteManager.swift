//
//  RouteManager.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation
import CoreLocation
import Combine
import Alamofire

final class RouteManager {
    func savePath(
        _ pathList: [CLLocationCoordinate2D]
    ) -> AnyPublisher<DataResponse<SavePathResponse, PathError>, Never> {
        let url = URL(string: "http://3.37.56.182:8080/v1/paths")!
        
        let pathArr = pathList.map {
            ["\($0.latitude)", "\($0.longitude)"]
        }
        
        var request = try? URLRequest(url: url, method: .post)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: Any] = [
            "path": pathArr,
            "area": 0.0
        ]
        
        try? request?.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        
        guard let request = request else {
            return Empty().eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate()
            .publishDecodable(type: SavePathResponse.self)
            .map { response in
                response.mapError { error in
                    print(error)
                    return PathError.otherUserPathError
                }
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getNearPath(
        _ pathList: [CLLocationCoordinate2D]
    ) -> AnyPublisher<DataResponse<OtherUserPathResponse, PathError>, Never> {
        let url = URL(string: "http://3.37.56.182:8080/v1/paths/within")!
        
        let pathArr = pathList.map {
            ["\($0.latitude)", "\($0.longitude)"]
        }
        
        var request = try? URLRequest(url: url, method: .post)
        request?.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let params: [String: [[String]]] = [
            "currentMap": pathArr
        ]
        
        try? request?.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
        
        guard let request = request else {
            return Empty().eraseToAnyPublisher()
        }
        
        return AF.request(request)
            .validate()
            .publishDecodable(type: OtherUserPathResponse.self)
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

enum PathError: Error {
    case otherUserPathError
    case savePathError
}
