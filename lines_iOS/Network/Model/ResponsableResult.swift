//
//  ResponseResult.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation

struct ResponseResult<T: Codable>: Codable {
    let httpStatus: Int?
    let success: Bool
    let error: String?
    let responseData: T?
    
    enum CodingKeys: CodingKey {
        case httpStatus, success, error, responseData
    }
}
