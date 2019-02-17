//
//  HttpClient.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

typealias ServerCompletionHandler = ((Data?, URLResponse?, Error?) -> Void)

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping ServerCompletionHandler) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping ServerCompletionHandler) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}


class HttpClient {
    
    private var session: URLSessionProtocol = URLSession.shared
    
    required init() {}
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func get( url: URL, completionHandler: @escaping ServerCompletionHandler) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
            }.resume()
    }
    
}

