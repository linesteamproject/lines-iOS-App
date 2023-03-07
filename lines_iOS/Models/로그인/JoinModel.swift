//
//  JoinModel.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation

struct JoinModel {
    let id: String = ""
    let oauthId: String
    let oauthType: LoginType
    
    var param: [String: String] {
        return [
            "id": id,
            "oauthId": oauthId,
            "oauthType": oauthType.type
        ]
    }
}
