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
    
    init(dictionary: NSDictionary) {
        
        title = dictionary["title"] as? String ?? ""
        overview = dictionary["overview"] as? String ?? ""
        if let posterPath = dictionary["poster_path"] as? String {
            posterUrl = NSURL(string: TMDBConfig.BaseUrl + posterPath)
        }
    }
    
    static func fetchNowPlaying(page page: Int?, language: String?, complete: ((movies: [Movie], error: NSError?) -> Void) ) {
        
        let url = NSURL(string: TMDBConfig.MovieNowPlaying)!
        let request = NSURLRequest(URL: url)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate: nil,
            delegateQueue: NSOperationQueue.mainQueue())
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request) { (data, response, error) in
            if let data = data {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(data, options: []) as? NSDictionary {
                    var movies = [Movie]()
                    if let dictionaries = responseDictionary["results"] as? [NSDictionary] {
                        for dictionary in dictionaries {
                            movies.append(Movie(dictionary: dictionary))
                        }
                    }
                    complete(movies: movies, error: error)
                }
            }
        }
        task.resume()
    }
}
