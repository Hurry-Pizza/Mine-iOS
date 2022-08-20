//
//  RankResponse.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

struct RankResponse: Response {
    var message: String?
    var data: Rank?
}

struct Rank: Decodable {
    var userId: Int?
    var userColor: String?
    var rank: Int?
}
