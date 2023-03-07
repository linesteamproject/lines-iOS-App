//
//  LoginModel.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation

struct LoginModel: Codable {
    let accessToken: String?
    let refreshToken: String?
    let isCreated: Bool?
}
