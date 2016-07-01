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
    var posterUrl: NSURL?
    var releaseDate: String?
    
    init(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String ?? ""
        overview = dictionary["overview"] as? String ?? ""
        if let posterPath = dictionary["poster_path"] as? String {
            posterUrl = NSURL(string: TMDBClient.BaseUrl + posterPath)
        }
        releaseDate = dictionary["release_date"] as? String ?? ""
    }
}
