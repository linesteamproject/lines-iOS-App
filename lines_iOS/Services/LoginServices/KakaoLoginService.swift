//
//  KakaoLoginService.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import KakaoSDKCommon
import RxKakaoSDKCommon
import KakaoSDKAuth
import RxKakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser
import RxSwift
import RxCocoa

class KakaoLoginService {
    private let disposeBag = DisposeBag()
    
    internal func login() -> Observable<OAuthToken> {
        let observable: Observable<OAuthToken>
        if UserApi.isKakaoTalkLoginAvailable() {
            observable = UserApi.shared.rx.loginWithKakaoTalk()
        } else {
            observable = UserApi.shared.rx.loginWithKakaoAccount()
        }
        return observable.take(1)
    }
    
    internal func getUserInfo() -> Observable<KakaoUserViewModel> {
        return UserApi.shared.rx.me()
            .map({ (user) -> KakaoUserViewModel in
                let userIdInt64Val = user.id ?? Int64(Date().timeIntervalSince1970)
                let userIdentifer = String(userIdInt64Val)
                let email = user.kakaoAccount?.email ?? UUID().uuidString + "@lines.com"
                let nick = user.kakaoAccount?.profile?.nickname ?? "User"
                
                return KakaoUserViewModel(userId: userIdentifer,
                                          email: email,
                                          nick: nick)
            })
            .asObservable()
            .retry(when: Auth.shared.rx.incrementalAuthorizationRequired())
            .take(1)
    }
}

struct KakaoUserModel {
    let userId: String
    let email: String
    let nick: String
}

struct KakaoUserViewModel {
    let model: KakaoUserModel
    init(userId: String,
         email: String,
         nick: String) {
        self.model = KakaoUserModel(userId: userId,
                                    email: email,
                                    nick: nick)
    }
    internal func getJoinViewModel() -> JoinViewModel {
        return JoinViewModel(id: "",
                             oauthId: self.model.userId,
                             oauthType: .kakao)
    }
}
