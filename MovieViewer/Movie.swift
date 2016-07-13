//
//  Movie.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

public class Movie {
    
    var id: Int?
    var title: String?
    var overview: String?
    var posterPath: String?
    var releaseDate: String?
    var isFavorited: Bool = false
    
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

extension Movie: FavoriteObject {

    // return favorite object id
    public func getId() -> Int {
        
        return id!
    }
    
    // set favorite value for favorite object
    public func setFavorite(isFavorited: Bool) {
        
        self.isFavorited = isFavorited
    }
}

extension Array where Element: Movie {
    
    // get list movie id
    func movieIds() -> [Int] {
        
        var ids = [Int]()
        for movie in self {
            ids.append(movie.id!)
        }
        return ids
    }
}