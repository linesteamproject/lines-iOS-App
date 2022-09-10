//
//  UserData.swift
//  lines_iOS
//
//  Created by mun on 2022/09/07.
//

import Foundation

class FirstLaunchChecker {
    static var isOnBoardingShown: Bool {
        get {
            UserDefaults.standard.bool(forKey: "IS_FIRST_LAUNCH")
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "IS_FIRST_LAUNCH")
        }
    }
    
    static var isDataSaved: Bool {
        get {
            UserDefaults.standard.bool(forKey: "IS_DATA_SAVED")
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "IS_DATA_SAVED")
        }
    }
    
    static var isNotLogin: Bool {
        return (UserData.accessToken.isEmpty && UserData.refreshToken.isEmpty)
    }
}

class UserData {
    static var accessToken: String {
        get {
            UserDefaults.standard.string(forKey: "ACCESS_TOKEN") ?? ""
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "ACCESS_TOKEN")
        }
    }
    
    static var refreshToken: String {
        get {
            UserDefaults.standard.string(forKey: "REFRESH_TOKEN") ?? ""
        }
        set(val) {
            UserDefaults.standard.setValue(val, forKey: "REFRESH_TOKEN")
        }
    }
}
