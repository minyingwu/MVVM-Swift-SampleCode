//
//  MovieList.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct MovieList: Codable {
    
    struct MovieItem: BaseData, Codable {
        
        let id: Int
        
        let popularity: Float?
        
        let title: String
        
        let poster_path: String?
        
        let backdrop_path: String?
        
    }
    
    let page: Int
    
    let total_pages: Int
    
    let results: [MovieItem]
}
