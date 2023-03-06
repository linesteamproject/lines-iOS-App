//
//  NetworkService.swift
//  lines_iOS
//
//  Created by mun on 2023/03/06.
//

import Alamofire
import RxSwift

enum ErrorTypeOnNetwork: Error {
    case refershErr
}
class NetworkService {
    private let forwardUrlStr = "http://15.165.161.188:8080/v1"
    internal func refresh() -> Observable<LoginViewModel> {
        let urlStr = forwardUrlStr+"/member/login/actions/refresh"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken,
            "X-AUTH-REFRESH-TOKEN": UserData.refreshToken])
        
        
        return Observable.create({ emitter in
            AFHandler.session.request(urlStr, method: .post,
                                      encoding: URLEncoding.default,
                                      headers: headers)
            .responseDecodable(of: ResponseResult<LoginModel>.self) {
                guard let model = $0.value?.responseData else {
                    emitter.onError(ErrorTypeOnNetwork.refershErr)
                    return
                }
                
                emitter.onNext(LoginViewModel(model: model))
                emitter.onCompleted()
            }
            
            return Disposables.create()
        })
    }
}
