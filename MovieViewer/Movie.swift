//
//  Movie.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

struct Movie {
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    
    init(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String ?? ""
        overview = dictionary["overview"] as? String ?? ""
        posterPath = dictionary["poster_path"] as? String ?? ""
        releaseDate = dictionary["release_date"] as? String ?? ""
    }
}
