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
    class func login(_ done: ((String?) -> Void)?) {
        guard (UserApi.isKakaoTalkLoginAvailable()) else {
            UserApi.shared.loginWithKakaoAccount {(oauthToken, error) in
                guard let _ = error else {
                    done?(oauthToken?.accessToken); return
                }
                done?(nil); return
            }
            return
        }
        
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print(error)
            }
            else {
                print("loginWithKakaoTalk() success.")

                //do something
                _ = oauthToken
            }
        }
    }
}
