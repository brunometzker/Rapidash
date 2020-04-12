//
//  HttpClientExtension.swift
//  App
//
//  Created by Bruno Metzker on 11/04/20.
//

import Foundation
import Vapor

extension Client {
    func fetch<T, U>(request: @escaping (Client) -> Future<Response>, dataType: T.Type, failedWhenStatusIsOneOf: [Int]?, errorType: U.Type) -> Future<ResponseDTO<T, U>> where T: Content, U: Content {
        return request(self).then { (response) -> EventLoopFuture<ResponseDTO<T, U>> in
            if let failureStatuses = failedWhenStatusIsOneOf {
                if failureStatuses.contains(Int(response.http.status.code)) {
                    do {
                        return try response.content.decode(U.self).then({ (decoded) -> EventLoopFuture<ResponseDTO<T, U>> in
                            return response.future(ResponseDTO(success: false, data: nil, error: decoded))
                        })
                    } catch {
                        return response.future(error: error)
                    }
                }
            }
            
            do {
                return try response.content.decode(T.self).then({ (decoded) -> EventLoopFuture<ResponseDTO<T, U>> in
                    return response.future(ResponseDTO(success: true, data: decoded, error: nil))
                })
            } catch {
                return response.future(error: error)
            }
        }
    }
}
