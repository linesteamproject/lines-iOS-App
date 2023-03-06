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
import RealmSwift

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
        window?.rootViewController = UINavigationController(rootViewController: SplashViewController())
        
        KakaoSDK.initSDK(appKey: "794c3c6e502b330cf0a9303a414d0da9")
        activeNaverLogin()
        migrationRealm()
        let _ = RealmController.shared
        
        return true

    }
    
    private func migrationRealm() {
        // 1. config 설정(이전 버전에서 다음 버전으로 마이그레이션될때 어떻게 변경될것인지)
        let config = Realm.Configuration(
            schemaVersion: 2, // 새로운 스키마 버전 설정
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 2 {
                    // 1-1. 마이그레이션 수행(버전 2보다 작은 경우 버전 2에 맞게 데이터베이스 수정)
                    migration.enumerateObjects(ofType: CardModel_Realm.className()) { oldObject, newObject in
                        newObject!["font"] = 폰트.나눔명조.rawValue
                        newObject!["textAlignment"] = 텍스트정렬.왼쪽.rawValue
                    }
                }
            }
        )
        
        // 2. Realm이 새로운 Object를 쓸 수 있도록 설정
        Realm.Configuration.defaultConfiguration = config
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.absoluteString.contains("kakao"), (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        if url.scheme?.contains("naver") == true {
            NaverThirdPartyLoginConnection.getSharedInstance()?.application(app, open: url, options: options)
            return true
        }
        
        return false
    }
    
    func activeNaverLogin() {
        let instance = NaverThirdPartyLoginConnection.getSharedInstance()
        
        // 네이버 앱으로 인증하는 방식 활성화
        instance?.isNaverAppOauthEnable = false
        // SafariViewController에서 인증하는 방식 활성화
        instance?.isInAppOauthEnable = true
        // 인증 화면을 아이폰의 세로모드에서만 적용
        instance?.isOnlyPortraitSupportedInIphone()
        instance?.appName = (Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String) ?? ""
            // 콜백을 받을 URL Scheme
        instance?.serviceUrlScheme = "naverloginonlines" // 앱을 등록할 때 입력한 URL Scheme
        instance?.consumerKey = kConsumerKey // 상수 - client id
        instance?.consumerSecret = kConsumerSecret // pw
        instance?.appName = kServiceAppName // app name
    }
}

