//
//  MovieCell.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit
import MGSwipeTableCell

class MovieCell: MGSwipeTableCell  {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var posterView: UIImageView!
    
    var isFavorited: Bool!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        posterView.layer.cornerRadius = 5
        posterView.clipsToBounds = true
    }

    func setData(movie: Movie) {
        
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        // erase previous image before loading new
        posterView.image = nil
        // retrieve poster
        if let posterUrl = movie.getPosterURLBySize(PosterSize.W154) {
            
            let request = NSURLRequest(URL: posterUrl)
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
        isFavorited = movie.isFavorited
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
        
        setActionButtons()
        toggleFavoriteStyle()
    }
    
    private func toggleFavoriteStyle() {
        
        if isFavorited! {
            backgroundColor = b3ecffBlueColor
            titleLabel.textColor = UIColor.blackColor()
            overviewLabel.textColor = UIColor.blackColor()
        } else {
            backgroundColor = UIColor.clearColor()
            titleLabel.textColor = UIColor.whiteColor()
            overviewLabel.textColor = UIColor.whiteColor()
        }
    }
    
    private func setActionButtons() {
        
        var isFavor = false
        if let isFavorited = isFavorited {
            isFavor = isFavorited
        }
        
        let loveIcon = UIImage(named: "love")
        let unLoveIcon = UIImage(named: "unlove")
        let shareIcon = UIImage(named: "share")
        
        //configure left buttons
        let favoriteBackground = isFavor ? ff9999RedColor : deepSkyBlueColor
        let favoriteIcon: UIImage? = isFavor ? unLoveIcon : loveIcon
        let favoriteButton = MGSwipeButton(title: "", icon: favoriteIcon, backgroundColor: favoriteBackground)
        leftButtons = [favoriteButton]
        leftSwipeSettings.transition = MGSwipeTransition.Rotate3D
        leftExpansion.buttonIndex = 0
        leftExpansion.fillOnTrigger = true
        
        //configure right buttons
        let shareButton = MGSwipeButton(title: "", icon: shareIcon, backgroundColor: b3ffb3GreenColor)
        rightButtons = [shareButton]
        rightSwipeSettings.transition = MGSwipeTransition.Rotate3D
    }
}
