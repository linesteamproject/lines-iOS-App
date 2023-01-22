//
//  RequestInterceptor.swift
//  lines_iOS
//
//  Created by mun on 2022/07/30.
//

import Alamofire

final class RequestInterceptor: Alamofire.RequestInterceptor {
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        completion(.success(req))
    }
}
