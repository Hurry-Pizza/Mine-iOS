//
//  OtherUserPathResponse.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

struct OtherUserPathResponse: Response {
    var message: String?
    var data: [Path]?
}

struct Path: Decodable {
    var longitude: Double
    var latitude: Double
}
