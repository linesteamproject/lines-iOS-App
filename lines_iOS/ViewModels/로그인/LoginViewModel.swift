//
//  LoginViewModel.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation
import RxSwift

struct LoginViewModel {
    let model: LoginModel
    init(model: LoginModel) {
        self.model = model
        
        UserData.accessToken = model.accessToken ?? ""
        UserData.refreshToken = model.refreshToken ?? ""
    }
    internal func isCreated() -> Bool {
        return self.model.isCreated ?? false
    }
}
