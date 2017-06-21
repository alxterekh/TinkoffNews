//
//  RequestSender.swift
//  TinkoffNews
//
//  Created by Alexander on 18/06/2017.
//  Copyright © 2017 Alexander Terekhov. All rights reserved.
//

import Foundation

class RequestSender: RequestTransmitter {
    
    fileprivate let timeout = 12
    
    let session: URLSession
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(timeout)
        configuration.timeoutIntervalForResource = TimeInterval(timeout)
        session = URLSession(configuration: configuration)
    }
    
    func send<T>(config: RequestConfig<T>, completionHandler: @escaping (Result<T>) -> Void) {
        
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(Result.Fail("url string can't be parser to URL"))
            return
        }
        
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(Result.Fail(error.localizedDescription))
                return
            }
            
            guard let data = data,
                let parsedModel: T = config.parser.parse(data: data) else {
                    completionHandler(Result.Fail("recieved data can't be parsed"))
                    return
            }
            
            completionHandler(Result.Success(parsedModel))
        }
        
        task.resume()
    }
}
