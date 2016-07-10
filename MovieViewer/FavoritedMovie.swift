//
//  FavoritedMovie.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/10/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift

class FavoritedMovie: Object {
    
    dynamic var id = 0
}

extension Results where T: FavoritedMovie {
    
    internal func contains(id: Int) -> Bool {
        
        return contains({ (favoritedMovie: FavoritedMovie) -> Bool in
            return favoritedMovie.id == id
        })
    }
    
    internal func indexOf(id: Int) -> Results.Index? {
        
        return indexOf({ (favoritedMovie: FavoritedMovie) -> Bool in
            return favoritedMovie.id == id
        })
    }
}
