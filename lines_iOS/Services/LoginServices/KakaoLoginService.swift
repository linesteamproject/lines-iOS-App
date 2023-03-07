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
        
        // MARK: 카카오톡 앱이 있는 경우
        UserApi.shared.rx.loginWithKakaoTalk()
                .subscribe(onNext:{ (oauthToken) in
                    print("loginWithKakaoTalk() success.")
                
                    //do something
                    _ = oauthToken
                }, onError: {error in
                    print(error)
                })
            .disposed(by: disposeBag)
        
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
