//
//  APIConfig.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

/* Example API KEY */

fileprivate let API_KEY: String = "dbbc5f9c21cd388646a6c5455acc8b6c"

/* Example API */
// http://api.themoviedb.org/3/discover/movie?api_key=328c283cd27bd1877d9080ccb1604c91&primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page=1

// http://api.themoviedb.org/3/movie/328111?api_key=328c283cd27bd1877d9080ccb1604c91

// http://image.tmdb.org/t/p/original/27RY4W57D6HWlY3FPmSphiIXco0.jpg

fileprivate let TMDB_URL: String = "http://api.themoviedb.org/3"

fileprivate let TMDB_IMAGE_URL: String = "http://image.tmdb.org/t/p/original"

enum AppAPIAction {
    //MARK: GET
    enum GET {
        case discoverByRelease(Int)
        case searchById(Int)
        case fetchImage(String)
    }
}

extension AppAPIAction.GET {
    var suffix: String {
        switch self {
        case .discoverByRelease(_):
            return "/discover/movie?"
        case .searchById(let id):
            return "/movie/\(id)?"
        case .fetchImage(let imgURL):
            return imgURL
        }
    }
    
    var urlString: String {
        switch self {
        case .discoverByRelease(let page):
            return TMDB_URL + self.suffix + "api_key=" + API_KEY + "&primary_release_date.lte=2016-12-31&sort_by=release_date.desc&page=\(page)"
        case .searchById(_):
            return TMDB_URL + self.suffix + "api_key=" + API_KEY
        case .fetchImage(_):
            return TMDB_IMAGE_URL + self.suffix
        }
    }
}
