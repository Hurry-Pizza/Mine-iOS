//
//  RankResponse.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

struct RankResponse: Response {
    var message: String?
    var data: RankData?
}

struct RankData: Decodable {
    var ranks: [Rank]?
    var startDay: String?
    var endDay: String?
}

struct Rank: Decodable {
    var userId: Int?
    var userNickname: String?
    var area: Double
}
