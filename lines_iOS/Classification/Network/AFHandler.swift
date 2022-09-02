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
    class func searchBook(by: [String: String], done: ((SearchBookStatus?) -> Void)?) {
        let url = "https://dapi.kakao.com/v3/search/book"
        guard let key = Bundle.main.infoDictionary?["KAKAO_APP_RESTFUL_KEY"] as? String
        else { done?(nil); return }
        
        let headers: HTTPHeaders = [ "Authorization": "KakaoAK " + key]
        session.request(url, method: .get, parameters: by, encoding: URLEncoding.default, headers: headers)
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
}
