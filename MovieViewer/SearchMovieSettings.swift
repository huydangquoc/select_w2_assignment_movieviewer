//
//  SearchMovieSettings.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/7/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

struct SearchMovieParam {
    
    static let apiKey = "api_key"
    static let query = "query"
    static let page = "page"
    static let language = "language"
    static let includeAdult = "include_adult"
    static let year = "year"
    static let primaryReleaseYear = "primary_release_year"
}

struct SearchMovieSettings {
    
    var query: String = ""              // CGI escaped string
    var page: Int = 1                // Minimum 1, maximum 1000.
    var language: Int? = nil            // ISO 639-1 code.
    var includeAdult: Bool = false       // Toggle the inclusion of adult titles. Expected value is: true or false
    var year: Int? = nil                // Filter the results release dates to matches that include this value.
    var primaryReleaseYear: Int? = nil  // Filter the results so that only the primary release dates have this value.
    
    func toParams() -> [String : String] {
        
        var params: [String : String] = [ : ]
        
        // set API Key
        params[SearchMovieParam.apiKey] = TMDBClient.ApiKey
        // set query
        let escapedQuery = query.stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet())
        params[SearchMovieParam.query] = escapedQuery
        // set page
        params[SearchMovieParam.page] = String(page)
        // set language
        if let language = language {
            params[SearchMovieParam.language] = String(language)
        }
        // set include_adult
        params[SearchMovieParam.includeAdult] = String(includeAdult)
        // set year
        if let year = year {
            params[SearchMovieParam.year] = String(year)
        }
        // set primary_release_year
        if let primaryReleaseYear = primaryReleaseYear {
            params[SearchMovieParam.primaryReleaseYear] = String(primaryReleaseYear)
        }
        
        return params
    }
}
