//
//  AppDelegate.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit
import SwiftyBeaver
import KakaoSDKAuth
import KakaoSDKUser
import KakaoSDKCommon
import NaverThirdPartyLogin

let log = SwiftyBeaver.self
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    internal func setRootViewController(_ vc: UIViewController) {
        DispatchQueue.main.async {
            self.window?.rootViewController = UINavigationController(rootViewController: vc)
        }
    }
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: StartViewController())
        
        KakaoSDK.initSDK(appKey: "794c3c6e502b330cf0a9303a414d0da9")
        activeNaverLogin()
        
        let _ = RealmController.shared
        
        for fontFamily in UIFont.familyNames {
            for fontName in UIFont.fontNames(forFamilyName: fontFamily) {
                print(fontName)
            }
        }
        return true

    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("munyong > url: \(url.absoluteString)")
        guard url.absoluteString.contains("kakao") else {
            NaverThirdPartyLoginConnection
                    .getSharedInstance()?
                    .receiveAccessToken(url)
            return false
        }
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        
        return false
    }
    
    func activeNaverLogin() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 앱으로 인증하는 방식 활성화
        instance?.isNaverAppOauthEnable = true
        // SafariViewController에서 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true
        // 인증 화면을 아이폰의 세로모드에서만 적용
        instance?.isOnlyPortraitSupportedInIphone()
        
        instance?.serviceUrlScheme = "naverloginonlines" // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = "31Z8n157vSc5G7GMvGU0" // 상수 - client id
        instance?.consumerSecret = "0dxTUpz13L" // pw
        instance?.appName = "lines" // app name
    }
}

