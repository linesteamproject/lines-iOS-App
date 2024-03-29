//
//  NaverLoginService.swift
//  lines_iOS
//
//  Created by mun on 2023/03/08.
//

import Foundation
import NaverThirdPartyLogin

class NaverLoginService: NSObject, NaverThirdPartyLoginConnectionDelegate {
    private let instance = NaverThirdPartyLoginConnection.getSharedInstance()
    var naverLoginClosure: ((NaverLoginResponse?) -> Void)?
    internal func login() {
        instance?.delegate = self
        guard let isValid = instance?.isValidAccessTokenExpireTimeNow(),
              isValid else {
            instance?.requestThirdPartyLogin()
            return
        }
        instance?.requestAccessTokenWithRefreshToken()
    }
    internal func logout() {
        instance?.requestDeleteToken()
    }
    // 로그인에 성공한 경우 호출
    func oauth20ConnectionDidFinishRequestACTokenWithAuthCode() {
        print("Success login")
        getInfo()
    }
    
    // referesh token
    func oauth20ConnectionDidFinishRequestACTokenWithRefreshToken() {
        getInfo()
    }
    
    // 로그아웃
    func oauth20ConnectionDidFinishDeleteToken() {
        print("log out")
    }
    
    // 모든 error
    func oauth20Connection(_ oauthConnection: NaverThirdPartyLoginConnection!, didFailWithError error: Error!) {
        print("error = \(error.localizedDescription)")
    }
    
    // RESTful API, id가져오기
    func getInfo() {
        guard let isValidAccessToken = instance?.isValidAccessTokenExpireTimeNow() else { return }
        
        if !isValidAccessToken {
            return
        }
        
        guard let tokenType = instance?.tokenType else { return }
        guard let accessToken = instance?.accessToken else { return }
        
        DispatchQueue.global().async { [weak self] in
            AFHandler.loginNaver(tokenType: tokenType,
                                 accessToken: accessToken) {
                guard let status = $0,
                      status.message == "success",
                    let response = status.response
                else { self?.naverLoginClosure?(nil); return }
                
                self?.naverLoginClosure?(response)
            }
        }
    }
}

