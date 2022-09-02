//
//  NaverLoginStatus.swift
//  lines_iOS
//
//  Created by mun on 2022/09/03.
//

struct NaverLoginStatus: Codable {
    let resultcode, message: String
    let response: NaverLoginResponse?
}

struct NaverLoginResponse: Codable {
    let age, id, email, nickname: String?
    let name: String?
}
