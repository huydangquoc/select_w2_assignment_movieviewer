//
//  MovieDetailViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 6/30/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var detailScrollView: UIScrollView!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var detailViewHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeightConstrain: NSLayoutConstraint!
    
    var movie: Movie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = movie!.title
        overviewLabel.text = movie!.overview
        if movie!.posterUrl != nil {
            posterView.setImageWithURL(movie!.posterUrl!)
        }
        durationLabel.text = movie!.releaseDate
        
        setScrollViewContentSize()
    }
    
    func setScrollViewContentSize() {
        
        overviewLabel.sizeToFit()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let detailViewHeight = overviewLabel.frame.origin.y + overviewLabel.bounds.height
        let contentViewHeight = screenSize.height + detailViewHeight - 200
        
        detailViewHeightConstrain.constant = detailViewHeight
        contentViewHeightConstrain.constant = contentViewHeight
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillLayoutSubviews() {
        setScrollViewContentSize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
