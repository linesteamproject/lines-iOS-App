//
//  ResponseResult.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation

struct ResponseResult<T: Codable>: Codable {
    let statusCode: Int?
    let message: String?
    let data: T?
    
    enum CodingKeys: CodingKey {
        case statusCode, message, data
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        statusCode = (try? values.decode(Int.self, forKey: .statusCode)) ?? nil
        message = (try? values.decode(String.self, forKey: .message)) ?? nil
        data = (try? values.decode(T.self, forKey: .data)) ?? nil
    }
}
