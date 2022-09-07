//
//  UserInfo.swift
//  lines_iOS
//
//  Created by mun on 2022/09/07.
//

import Foundation

struct UserInfo {
    static let shared = UserInfo()
    internal var isLogin: Bool = false
    private var nickName: String = ""
    private var loginType: LoginType?
}
