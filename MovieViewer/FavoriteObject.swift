//
//  FavoriteObject.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

public protocol FavoriteObject {
    
    // return favorite object id
    func getId() -> Int
    
    // set favorite value for favorite object
    func setFavorite(isFavorited: Bool) -> Void
}
