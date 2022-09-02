//
//  KakaoLoginController.swift
//  lines_iOS
//
//  Created by mun on 2022/08/05.
//

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class KakaoLoginController: NSObject {
    class func login(_ done: ((Bool) -> Void)?) {
        guard (UserApi.isKakaoTalkLoginAvailable()) else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                guard let _ = error else {
                    let accessToken = oauthToken?.accessToken
                    done?(true)
                    return
                }
                done?(false)
            }
            return
        }
        
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            guard let _ = error else {
                let accessToken = oauthToken?.accessToken
                done?(true)
                return
            }
            done?(false)
        }
    }
}
