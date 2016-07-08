//
//  FiltersViewController.swift
//  MovieViewer
//
//  Created by Dang Quoc Huy on 7/7/16.
//  Copyright © 2016 Dang Quoc Huy. All rights reserved.
//

import UIKit

let startYear = 1916

class FiltersViewController: UITableViewController {

    @IBOutlet weak var adultContentSwitch: UISwitch!
    @IBOutlet weak var releaseYearPicker: UIPickerView!
    @IBOutlet weak var primaryReleaseYearPicker: UIPickerView!
    
    var settings = SearchMovieSettings()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init delegate
        releaseYearPicker.dataSource = self
        releaseYearPicker.delegate = self
        primaryReleaseYearPicker.dataSource = self
        primaryReleaseYearPicker.delegate = self
        
        // Init UI
        adultContentSwitch.on = settings.includeAdult
        releaseYearPicker.selectRow(yearToRow(settings.year), inComponent: 0, animated: false)
        primaryReleaseYearPicker.selectRow(yearToRow(settings.primaryReleaseYear), inComponent: 0, animated: false)
    }
    
    @IBAction func onAdultContentSwitch(sender: AnyObject) {
        
        settings.includeAdult = adultContentSwitch.on
    }
    
    func getTitleData(row: Int) -> String {
        
        var titleData = "Any"
        if row != 0 { titleData = "\(startYear + row)" }
        return titleData
    }
    
    func convertYeartoInt(value: String) -> Int? {
        
        if value == "Any" {
            return nil
        } else {
            return Int(value)
        }
    }
    
    func yearToRow(year: Int?) -> Int {
        
        if year == nil { return 0 }
        return year! - startYear
    }
}

extension FiltersViewController: UIPickerViewDataSource {
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 101
    }
}

extension FiltersViewController: UIPickerViewDelegate {
    
    // Called by the picker view when it needs the title to use for a given row in a given component
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return getTitleData(row)
    }
    
    // Called by the picker view when it needs the styled title to use for a given row in a given component
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let myTitle = NSAttributedString(string: getTitleData(row), attributes: [NSFontAttributeName:UIFont(name: "Georgia", size: 12.0)!,NSForegroundColorAttributeName:UIColor.blueColor()])
        return myTitle
    }
    
    // Called by the picker view when the user selects a row in a component.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        let value = getTitleData(row)
        if pickerView.restorationIdentifier == "releaseYearPicker" {
            settings.year = convertYeartoInt(value)
        } else if pickerView.restorationIdentifier == "primaryReleaseYearPicker" {
            settings.primaryReleaseYear = convertYeartoInt(value)
        }
    }
}
