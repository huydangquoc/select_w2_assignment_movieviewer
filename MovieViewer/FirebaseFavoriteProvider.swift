//
//  FirebaseFavoriteProvider.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/13/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import Foundation
import Firebase
import MBProgressHUD

public class FirebaseFavoriteProvider: FavoriteProvider {
    
    var ref: FIRDatabaseReference!
    
    public override func prepare(complete: ((error: NSError?) -> Void) ) {
        
        // init firebase db instance
        ref = FIRDatabase.database().reference()
        // login as anonymous user
        FIRAuth.auth()?.signInAnonymouslyWithCompletion({ (user: FIRUser?, error: NSError?) in
            
            complete(error: error)
        })
    }
    
    // populate favorite values to list of favorite object
    public override func populateData(favoriteObjectIds: [Int]) {
        
        for objectId in favoriteObjectIds {
            let object = dataSource?.getFavoriteObjectById(self, favoriteObjectId: objectId)
            ref.child("anonymous/favorited/\(objectId)").observeEventType(.Value, withBlock: { (snapshot: FIRDataSnapshot) in
                
                object?.setFavorite(snapshot.exists())
                self.delegate?.favoriteProvider(self, objectIdDidChangedFavoriteValue: objectId)
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    
    // save favorite value for a favorite object to database of provider
    public override func saveFavorite(favoriteObject: FavoriteObject, isFavorited: Bool) {
        
        let objectId = favoriteObject.getFavoriteObjectId()
        if isFavorited {
            self.ref.child("anonymous/favorited/\(objectId)").setValue(true)
        } else {
            self.ref.child("anonymous/favorited/\(objectId)").setValue(nil)
        }
    }
    
    deinit {
        
        guard ref != nil else { return }
        ref.removeAllObservers()
    }
}
