//
//  MovieDetail.swift
//  BookMyMovie
//
//  Created by Victor on 2019/2/14.
//  Copyright © 2019 Victor. All rights reserved.
//

import Foundation

struct MovieDetail: BaseData, Codable {
    
    struct Genres: Codable {
        var name: String?
    }
    
    let genres: [Genres]?
    
    let original_language: String?
    
    let overview: String?
    
    let runtime: Int?
}
