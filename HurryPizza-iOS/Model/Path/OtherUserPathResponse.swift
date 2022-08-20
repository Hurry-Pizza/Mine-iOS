//
//  OtherUserPathResponse.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

struct OtherUserPathResponse: Response {
    var message: String?
    var data: [Polygon]?
}

struct Polygon: Decodable {
    var pathId: Int?
    var path: [[Double]]?
    var userId: Int?
    var userNickname: String?
    var color: String?
    var mine: Bool?
}
