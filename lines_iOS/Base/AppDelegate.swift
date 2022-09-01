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

let log = SwiftyBeaver.self
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: MainViewController())
        
        KakaoSDK.initSDK(appKey: "794c3c6e502b330cf0a9303a414d0da9")
        return true

    }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        return false
    }

}

