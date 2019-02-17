//
//  APISession.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/17.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

class APISession {
    
    static let shared = APISession()
    
    private init(){}
    
    private lazy var httpClient: HttpClient = {
        return HttpClient()
    }()
    
    func getMovieListByRelease(onPage num: Int,
                              completionHandler: @escaping ServerCompletionHandler) {
        if let url = URL(string: AppAPIAction.GET.discoverByRelease(num).urlString) {
            httpClient.get(url: url) { (data, response, error) in
                completionHandler(data, response, error)
            }
        }else {
            completionHandler(nil, nil, ErrorState.requestURLError)
        }
    }
    
    func getDetailMovieInfo(by movieId: Int,
                              completionHandler: @escaping ServerCompletionHandler) {
        if let url = URL(string: AppAPIAction.GET.searchById(movieId).urlString) {
            httpClient.get(url: url) { (data, response, error) in
                completionHandler(data, response, error)
            }
        }else {
            completionHandler(nil, nil, ErrorState.requestURLError)
        }
    }
}
