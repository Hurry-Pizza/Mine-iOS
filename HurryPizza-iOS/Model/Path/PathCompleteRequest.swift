//
//  PathCompleteRequest.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

#warning("User 정보를 jwt로 받으시는지?")
struct PathCompleteRequest: Encodable {
    var pathList: [Double]
}
