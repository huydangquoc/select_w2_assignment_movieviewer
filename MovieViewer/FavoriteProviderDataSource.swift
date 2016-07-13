//
//  FavoriteProviderDataSource.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation

public protocol FavoriteProviderDataSource {

    // get favorite object by object id
    func favoriteProvider(favoriteProvider: FavoriteProvider, favoriteObjectId objectId: Int) -> FavoriteObject
}
