//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import SteviaLayout

class MovieCell: UITableViewCell {
    
    var infoView = UIView()
    
    var titleLabel = UILabel()
    var overviewLabel = UILabel()
    var posterView = UIImageView()
    
    convenience init() {
        self.init(frame:CGRectZero)
//         This is only needed for live reload as injectionForXcode
        // doesn't swizzle init methods.
//        render()
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        sv(
            posterView.width(60).height(100),
            infoView.sv(
                titleLabel,
                overviewLabel
            )
        )
        
        layout(
            10,
            |-posterView-20-infoView|
            
        )
        
        infoView.layout(
            |titleLabel,
            |overviewLabel
        )
        
//        |-posterView-15-infoView-|
        alignHorizontally(posterView,infoView)

        overviewLabel.numberOfLines = 0
//
//        posterView.size(50).centerVertically()
//        alignHorizontally(|-20-posterView-titleLabel-20-|)
    }

    func nameStyle(l:UILabel) {
        l.font = .systemFontOfSize(24)
        l.textColor = .blueColor()
    }
    
    func overviewStyle(l:UILabel) {
        l.font = .systemFontOfSize(24)
        l.textColor = .blueColor()
        l.numberOfLines = 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterView.layer.cornerRadius = 5
        posterView.clipsToBounds = true
    }

    func setData(movie: Movie) {
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        
        guard (movie.posterPath != nil) else { return }
        
        let posterUrl = NSURL(string: TMDBClient.BaseImageW154Url + movie.posterPath!)
        let request = NSURLRequest(URL: posterUrl!)
        posterView.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
            
            // image come frome cache
            if response == nil {
                self.posterView.image = image
            // image come frome network
            } else {
                self.posterView.setImageWithFadeIn(image)
            }
        }, failure: { (request, response, error) in
            
            // process error here
            debugPrint(error.localizedDescription)
        })
    }
    
    func setTheme() {
        
        titleLabel.textColor = UIColor.whiteColor()
        overviewLabel.textColor = UIColor.whiteColor()
        
        // clear cell background to get rid of WHITE background by default
        backgroundColor = UIColor.clearColor()
        // config cell selected background
        let customSelectionView = UIView(frame: frame)
        customSelectionView.backgroundColor = themeColor
        selectedBackgroundView = customSelectionView
    }
}
