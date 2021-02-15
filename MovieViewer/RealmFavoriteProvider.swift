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
    
    public override func prepare(complete: ((error: NSError?) -> Void) ) {
        
        // init realm instance
        do {
            realm = try Realm()
            favoritedMovies = realm.objects(FavoriteRealmObject.self)
            complete(error: nil)
        } catch let error as NSError {
            complete(error: error)
        }
    }
    
    // populate favorite values to list of favorite object
    public override func populateData(favoriteObjectIds: [Int]) {
        
        for objectId in favoriteObjectIds {
            let object = dataSource?.getFavoriteObjectById(self, favoriteObjectId: objectId)
            object?.setFavorite(contains(objectId))
        }
    }
    
    // save favorite value for a favorite object to database of provider
    public override func saveFavorite(favoriteObject: FavoriteObject, isFavorited: Bool) {
        
        let objectId = favoriteObject.getFavoriteObjectId()
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
                populateData([objectId])
                delegate?.favoriteProvider(self, objectIdDidChangedFavoriteValue: objectId)
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
                populateData([objectId])
                delegate?.favoriteProvider(self, objectIdDidChangedFavoriteValue: objectId)
            }
        }
    }
    
    private func contains(objectId: Int) -> Bool {
        
        let predicate = NSPredicate(format: "id = %d", objectId)
        return favoritedMovies.filter(predicate).count > 0
    }
}