//
//  FavoritedMovie.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/10/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift

class FavoriteRealmObject: Object {
    
    dynamic var id = 0
}

extension Results where T: FavoriteRealmObject {
    
    internal func contains(id: Int) -> Bool {
        
        return contains({ (favoritedMovie: FavoriteRealmObject) -> Bool in
            return favoritedMovie.id == id
        })
    }
    
    internal func indexOf(id: Int) -> Results.Index? {
        
        return indexOf({ (favoritedMovie: FavoriteRealmObject) -> Bool in
            return favoritedMovie.id == id
        })
    }
}
