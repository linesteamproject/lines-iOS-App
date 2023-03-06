//
//  LoginModel.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation

struct LoginViewModel {
    let model: LoginModel
    init(model: LoginModel) {
        self.model = model
        
        UserData.accessToken = model.accessToken ?? ""
        UserData.refreshToken = model.refreshToken ?? ""
    }
}

struct LoginModel: Codable {
    let accessToken: String?
    let refreshToken: String?
    let isCreated: Bool?
}
