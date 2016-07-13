//
//  FavoriteProvider.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

public class FavoriteProvider {
    
    public var dataSource: FavoriteProviderDataSource?
    
    // populate favorite values to list of favorite object
    public func populateData(favoriteObjectIds: [Int]) {
    
        // empty implementation
        // subclass must implement this method
    }
    
    // save favorite value for a favorite object to database of provider
    public func saveFavorite(favoriteObject: FavoriteObject, isFavorited: Bool) {
    
        // empty implementation
        // subclass must implement this method
    }
}
