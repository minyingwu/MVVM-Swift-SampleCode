//
//  MovieListViewModel.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import UIKit
import Kingfisher

class MovieListViewModel: BaseViewModel {
    
    private lazy var httpClient: HttpClient = {
        return HttpClient()
    }()
    
    init(httpClient: HttpClient? = nil) {
        super.init()
        if httpClient != nil { self.httpClient = httpClient! }
    }
    
    override func getUpdatedDataCell(at indexPath: IndexPath, _ cell: UITableViewCell) -> UITableViewCell {
        if let tableCell = cell as? MainTableCell {
            tableCell.tag = indexPath.row
            let movieItem = dataList[indexPath.row] as! MovieList.MovieItem
            tableCell.movieTitleLabel.text = movieItem.title
            
            if let popularity = movieItem.popularity {
                tableCell.ratingLabel.text = "Popularity: " + String(popularity)
            }
            
            if let posterURL = movieItem.poster_path {
                let processor = BlurImageProcessor(blurRadius: 60)
                tableCell.posterImageView.kf.setImage(
                    with: URL(string: AppAPIAction.GET.fetchImage(posterURL).urlString),
                    options: [.processor(processor)])
            }else {
                tableCell.posterImageView.image = nil
            }
            
            if let backdropURL = movieItem.backdrop_path {
                tableCell.backdropImageView.kf.setImage(with: URL(string: AppAPIAction.GET.fetchImage(backdropURL).urlString))
            }else {
                tableCell.backdropImageView.image = #imageLiteral(resourceName: "no_pic")
            }
            
            return tableCell
            
        }
        
        return UITableViewCell()
    }
    
    override func fetchDataListfromServer() {
        APISession.shared.getMovieListByRelease(onPage: 1) { (data, response, error) in
            guard error == nil else {
                switch URLError.Code(rawValue: (error! as NSError).code) {
                case .notConnectedToInternet:
                    self.errorState = ErrorState.networkError
                default:
                    self.errorState = ErrorState.requestURLError
                }
                return
            }
            if let data = data,
                let movieList = try? JSONDecoder().decode(MovieList.self, from: data) {
                self.numberOfPages = movieList.total_pages
                self.dataList = movieList.results
            }
        }
    }
    
    override func fetchMoreData(with pageNum: Int) {
        APISession.shared.getMovieListByRelease(onPage: pageNum) { (data, response, error) in
            if let data = data,
                let movieList = try? JSONDecoder().decode(MovieList.self, from: data) {
                self.loadedPage += 1
                self.dataList.append(contentsOf: movieList.results)
            }
        }
    }

}

