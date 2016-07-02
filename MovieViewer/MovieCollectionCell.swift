//
//  MovieCollectionCell.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/1/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class MovieCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var posterView: UIImageView!
    
    func setData(movie: Movie) {
        
        if movie.posterUrl != nil {
            posterView.setImageWithURL(movie.posterUrl!)
        }
    }
}
