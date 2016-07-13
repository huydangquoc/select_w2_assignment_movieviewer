//
//  RealmFavoriteProvider.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation
import RealmSwift

public class RealmFavoriteProvider: FavoriteProvider {
    
    var realm: Realm!
    var favoritedMovies: Results<FavoriteRealmObject>!
    
    override init() {
        super.init()
        
        // init realm instance
        do {
            realm = try Realm()
            favoritedMovies = realm.objects(FavoriteRealmObject.self)
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    // populate favorite values to list of favorite object
    public override func populateData(favoriteObjectIds: [Int]) {
        
        for objectId in favoriteObjectIds {
            let object = dataSource?.favoriteProvider(self, favoriteObjectId: objectId)
            object?.setFavorite(contains(objectId))
        }
    }
    
    // save favorite value for a favorite object to database of provider
    public override func saveFavorite(favoriteObject: FavoriteObject, isFavorited: Bool) {
        
        let objectId = favoriteObject.getId()
        let isContained: Bool = contains(objectId)
        if isFavorited {
            if !isContained{
                do {
                    try realm.write() {
                        let favoritedMovie = FavoriteRealmObject()
                        favoritedMovie.id = objectId
                        realm.add(favoritedMovie)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                favoriteObject.setFavorite(isFavorited)
            }
        } else {
            if let index = favoritedMovies.indexOf(objectId) {
                let favoritedMovie = favoritedMovies[index]
                do {
                    try realm.write() {
                        realm.delete(favoritedMovie)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
                favoriteObject.setFavorite(isFavorited)
            }
        }
    }
    
    private func contains(objectId: Int) -> Bool {
        
        let predicate = NSPredicate(format: "id = %d", objectId)
        return favoritedMovies.filter(predicate).count > 0
    }
}