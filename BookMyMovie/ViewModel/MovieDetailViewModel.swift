//
//  MovieDetailViewModel.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/17.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailViewModel: BaseViewModel {
    
    var movieId: Int = 0
    
    init(with id: Int) {
        super.init()
        self.movieId = id
    }
    
    override func fetchDataListfromServer(completionHandler: CompletionHandler? = nil) {
        APISession.shared.getDetailMovieInfo(by: movieId) { (data, response, error) in
            guard error == nil else {
                switch URLError.Code(rawValue: (error! as NSError).code) {
                case .notConnectedToInternet:
                    self.errorState = ErrorState.networkError
                default:
                    self.errorState = ErrorState.requestURLError
                }
                completionHandler?()
                return
            }
            if let data = data,
                let movieDetail = try? JSONDecoder().decode(MovieDetail.self, from: data) {
                self.dataList = [movieDetail]
            }
            completionHandler?()
        }
    }
}
