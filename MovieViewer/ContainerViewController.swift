//
//  ContainerViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/1/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let moviesViewController = segue.destinationViewController as! MoviesViewController
        
        switch restorationIdentifier! {
        case "topRated":
            moviesViewController.viewMode = .TopRated
        default:
            moviesViewController.viewMode = .NowPlaying
        }
    }

}
