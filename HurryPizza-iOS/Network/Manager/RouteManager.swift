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
    static let shared = RouteManager()
    
    let kEarthRadius = 6378137.0
    
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
    
    func radians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }
    
    func regionArea(locations: [CLLocationCoordinate2D]) -> Double {
        guard locations.count > 2 else { return 0 }
        var area = 0.0
        
        for i in 0..<locations.count {
            let p1 = locations[i > 0 ? i - 1 : locations.count - 1]
            let p2 = locations[i]
            
            area += radians(degrees: p2.longitude - p1.longitude) * (2 + sin(radians(degrees: p1.latitude)) + sin(radians(degrees: p2.latitude)) )
        }
        area = -(area * kEarthRadius * kEarthRadius / 2)
        return max(area, -area) // In order not to worry about is polygon clockwise or counterclockwise defined.
    }
}

enum PathError: Error {
    case otherUserPathError
    case savePathError
}
