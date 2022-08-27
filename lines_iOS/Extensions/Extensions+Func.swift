//
//  Extensions+Func.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import UIKit

func topViewController(baseParam: UIViewController? = nil) -> UIViewController? {
    var base = baseParam
    if base == nil {
        base = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .map({$0 as? UIWindowScene})
            .compactMap({$0})
            .first?.windows
            .filter({$0.isKeyWindow}).first?.rootViewController
    }
    
    if let nav = base as? UINavigationController {
        return topViewController(baseParam: nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
        if let selected = tab.selectedViewController {
            return topViewController(baseParam: selected)
        }
    }
    if let presented = base?.presentedViewController {
        return topViewController(baseParam: presented)
    }
    return base
}

func dismissViewControllerUntil(vcID: String?) {
    guard let top = topViewController(),
          getId(top.description) != vcID
    else { return }

    top.dismiss(animated: true) {
        DispatchQueue.main.async {
            dismissViewControllerUntil(vcID: vcID)
        }
    }
    
    func getId(_ id: String?) -> String? {
        return id?.components(separatedBy: ".").last?.components(separatedBy: ":").first
    }
}
