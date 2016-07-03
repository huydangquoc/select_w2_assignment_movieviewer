//
//  UIImageView.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/2/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

extension UIImageView {
    
    // Set image with fade in animation
    func setImageWithFadeIn(image: UIImage) {
        
        self.alpha = 0.0
        self.image = image
        UIView.animateWithDuration(1.5) {
            self.alpha = 1.0
        }
    }
    
    // Load thumbnail, then load full size image
    func setImageWithThumbnail(thumbnailLink: String, imageLink: String) {
        
        let thumbnailURL = NSURL(string: thumbnailLink)!
        // load thumbnail first
        let request = NSURLRequest(URL: thumbnailURL)
        self.setImageWithURLRequest(request, placeholderImage: nil, success: { (request, response, image) in
            
            // load thumbnail image
            self.image = image
            // then, load full size image
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let url = NSURL(string: imageLink)!
                self.setImageWithURL(url)
            })
        }, failure: { (request, response, error) in
            
            // process error here
            debugPrint(error.localizedDescription)
        })
    }
}
