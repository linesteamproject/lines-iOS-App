//
//  AFHandler.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Foundation
import Alamofire
class AFHandler {
    static var defaultSession: Session {
        let interceptor = RequestInterceptor()
#if DEBUG
        return Alamofire.Session(interceptor: interceptor, eventMonitors: [EventMonitor()])
#else
        return Alamofire.Session(interceptor: interceptor)
#endif
    }
    static let session = defaultSession
    class func searchBook(by: [String: Any], done: ((SearchBookStatus?) -> Void)?) {
        let url = "https://dapi.kakao.com/v3/search/book"
        guard let key = Bundle.main.infoDictionary?["KAKAO_APP_RESTFUL_KEY"] as? String
        else { done?(nil); return }
        
        let headers: HTTPHeaders = ["Authorization": "KakaoAK " + key]
        session.request(url, method: .get,
                        parameters: by,
                        encoding: URLEncoding.default,
                        headers: headers)
            .responseDecodable(of: SearchBookStatus.self) {
                print($0.debugDescription)
                done?($0.value)
        }
    }
    
    class func loginNaver(tokenType: String, accessToken: String, done:((NaverLoginStatus?) -> Void)?) {
        let urlStr = "https://openapi.naver.com/v1/nid/me"
        let url = URL(string: urlStr)!
        
        let authorization = "\(tokenType) \(accessToken)"
        
        session.request(url, method: .get,
                        parameters: nil,
                        encoding: JSONEncoding.default,
                        headers: ["Authorization": authorization])
        .responseDecodable(of: NaverLoginStatus.self) {
            done?($0.value)
        }
    }
    
    class func login(_ model: JoinModel, done: ((LoginResponse?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/member/login"
        session.request(urlStr, method: .post,
                        parameters: model.param,
                        encoding: JSONEncoding.default)
        .responseDecodable(of: ResponseResult<LoginResponse>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
    
    class func logout(done: ((Bool) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/member/logout"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken,
            "X-AUTH-REFRESH-TOKEN": UserData.refreshToken])
        session.request(urlStr, method: .put,
                        encoding: URLEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<LogoutResponse>.self) {
            let value = $0.value
            done?(value?.httpStatus == 200 && value?.success == true)
        }
    }
    
    class func resign(done: ((Bool) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/member"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        session.request(urlStr, method: .delete,
                        encoding: URLEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<LogoutResponse>.self) {
            let value = $0.value
            done?(value?.httpStatus == 200 && value?.success == true)
        }
    }
    
    class func refresh(done: ((LoginResponse?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/member/login/actions/refresh"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken,
            "X-AUTH-REFRESH-TOKEN": UserData.refreshToken])
        session.request(urlStr, method: .post,
                        encoding: URLEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<LoginResponse>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
    
    class func getCardDatas(done: ((CardInfoList?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/lines"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        session.request(urlStr, method: .get,
                        encoding: JSONEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<CardInfoList>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
    
    class func saveCardData(done: ((SaveCardResponse?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/lines"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        let param = ReadTextController.shared.param
        session.request(urlStr, method: .post,
                        parameters: param,
                        encoding: JSONEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<SaveCardResponse>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
    
    class func saveRealmCardData(_ cardModel: CardModel, done: ((SaveCardResponse?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/lines"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        let param = cardModel.param
        session.request(urlStr, method: .post,
                        parameters: param,
                        encoding: JSONEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<SaveCardResponse>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
    
    class func shareCardLog(id: String, done: ((ShareCardResponse?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/lines/" + id + "/share-log"
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        session.request(urlStr, method: .post,
                        encoding: JSONEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<ShareCardResponse>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
    
    class func deleteCardData(id: String?,
                              done: ((Bool?) -> Void)?) {
        guard let id = id, !id.isEmpty else { done?(nil); return }
        
        let urlStr = "http://15.165.161.188:8080/v1/lines"+"/"+id
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        session.request(urlStr, method: .delete,
                        encoding: URLEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<JsonNull>.self) {
            let value = $0.value
            done?(value?.success)
        }
    }
    
    class func putCardData(id: String, done: ((SaveCardResponse?) -> Void)?) {
        let urlStr = "http://15.165.161.188:8080/v1/lines"+"/"+id
        let headers = HTTPHeaders(["Authorization": "bearer " + UserData.accessToken])
        let param = ReadTextController.shared.getPutParam(id: id)
        session.request(urlStr, method: .put,
                        parameters: param,
                        encoding: JSONEncoding.default,
                        headers: headers)
        .responseDecodable(of: ResponseResult<SaveCardResponse>.self) {
            let value = $0.value
            done?(value?.responseData)
        }
    }
}
