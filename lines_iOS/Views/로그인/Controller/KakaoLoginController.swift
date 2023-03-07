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
    static let shared = KakaoLoginController()
    func login(_ done: ((KakaoUser?) -> Void)?) {
        guard (UserApi.isKakaoTalkLoginAvailable()) else {
            UserApi.shared.loginWithKakaoAccount { [weak self] (oauthToken, error) in
                guard nil == error else {
                    done?(nil); return
                }
                let accessToken = oauthToken?.accessToken
                self?.sendUserInfoAfterKakaoLogin { done?($0) }
            }
            return
        }
        
        UserApi.shared.loginWithKakaoTalk { [weak self] (oauthToken, error) in
            guard nil == error else {
                done?(nil); return
            }
            let accessToken = oauthToken?.accessToken
            self?.sendUserInfoAfterKakaoLogin { done?($0) }
        }
    }
    
    private func sendUserInfoAfterKakaoLogin(done: ((KakaoUser?) -> Void)?) {
        UserApi.shared.me() {(user, error) in
            guard error == nil, let userIdInt64Val = user?.id else {
                done?(nil)
                return
            }
            
            let userIdentifer = String(userIdInt64Val)
            let email = user?.kakaoAccount?.email ?? UUID().uuidString + "@lines.com"
            let nick = user?.kakaoAccount?.profile?.nickname ?? "User"
            done?(KakaoUser(userId: userIdentifer,
                            email: email,
                            nick: nick))
        }
    }
}

struct KakaoUser {
    let userId: String
    let email: String
    let nick: String
}
