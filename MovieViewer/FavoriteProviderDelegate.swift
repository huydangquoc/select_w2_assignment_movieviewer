//
//  FavoriteProviderDelegate.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

public protocol FavoriteProviderDelegate {
    
    // object Id did changed favorite value
    func favoriteProvider(favoriteProvider: FavoriteProvider, objectIdDidChangedFavoriteValue objectId: Int) -> Void
}
