//
//  Response.swift
//  HurryPizza-iOS
//
//  Created by 고병학 on 2022/08/20.
//

import Foundation

protocol Response: Decodable {
    
    associatedtype T: Decodable
    
    var message: String? { get }
    var data: T? { get }
}
