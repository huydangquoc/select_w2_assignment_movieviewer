//
//  TMDBConfig.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

struct TMDBConfig {
    static let ApiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    static let BaseUrl = "http://image.tmdb.org/t/p/w500"
    static let MovieNowPlaying = "http://api.themoviedb.org/3/movie/now_playing?api_key=\(ApiKey)"
}