//
//  Movie.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

var favoritedMovies = [Int]()

struct Movie {
    
    var id: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var isFavorited: Bool {
        get {
            
            if let id = self.id {
                return favoritedMovies.contains(id)
            }
            return false
        }
        
        set(newValue) {
            
            if let id = self.id {
                if newValue {
                    if !favoritedMovies.contains(id) {
                        favoritedMovies.append(id)
                    }
                } else {
                    if let index = favoritedMovies.indexOf(id) {
                        favoritedMovies.removeAtIndex(index)
                    }
                }
            }
        }
    }
    
    init(dictionary: NSDictionary) {
        
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        overview = dictionary["overview"] as? String
        posterPath = dictionary["poster_path"] as? String ?? nil
        releaseDate = dictionary["release_date"] as? String
    }
    
    func getPosterURLBySize(size: PosterSize) -> NSURL? {
        
        guard let posterPathSafe = posterPath else { return nil }
        
        let posterPathBySize = TMDBClient.BaseImageUrl + size.rawValue + "/\(posterPathSafe)"
        let url = NSURL(string: posterPathBySize)
        return url
    }
}
