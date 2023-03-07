//
//  JoinViewModel.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Foundation

struct JoinViewModel {
    var joinModel: JoinModel
    init(id: String,
         oauthId: String,
         oauthType: LoginType) {
        self.joinModel = JoinModel(oauthId: oauthId,
                                   oauthType: oauthType)
    }
    
    internal func getParam() -> [String: String] {
        return [
            "id": joinModel.id,
            "oauthId": joinModel.oauthId,
            "oauthType": joinModel.oauthType.type
        ]
    }
}
