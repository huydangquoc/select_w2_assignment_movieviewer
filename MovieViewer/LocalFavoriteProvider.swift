//
//  LocalFavoriteProvider.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

var favoritedMovies = [Int]()

public class LocalFavoriteProvider: FavoriteProvider {
    
    // populate favorite values to list of favorite object
    public override func populateData(favoriteObjectIds: [Int]) {
        
        for objectId in favoriteObjectIds {
            let object = dataSource?.favoriteProvider(self, favoriteObjectId: objectId)
            object?.setFavorite(favoritedMovies.contains(objectId))
        }
    }
    
    // save favorite value for a favorite object to database of provider
    public override func saveFavorite(favoriteObject: FavoriteObject, isFavorited: Bool) {
        
        let objectId = favoriteObject.getId()
        if isFavorited {
            if !favoritedMovies.contains(objectId) {
                favoritedMovies.append(objectId)
                favoriteObject.setFavorite(isFavorited)
            }
        } else {
            if let index = favoritedMovies.indexOf(objectId) {
                favoritedMovies.removeAtIndex(index)
                favoriteObject.setFavorite(isFavorited)
            }
        }
    }
}