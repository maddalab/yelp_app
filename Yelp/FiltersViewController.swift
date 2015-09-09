//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Bhaskar Maddala on 9/8/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
     optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String:AnyObject])
}

class FiltersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CategoryTableViewCellDelegate {

    @IBOutlet weak var categoriesTableView: UITableView!
    weak var delegate : FiltersViewControllerDelegate?
    
    let categories = Business.searchCategories()
    var switchStates = [Int:Bool]()
    
    let sections = ["":["Offering A Deal"],
        "Distance": ["2 blocks", "1 mile", "5 miles"],
        "Sort By": ["Best Matched", "Distance", "Highest Rated"],
        "Categories": []
    ]
    
    let sectionHeaders = [ "", "Distance", "Sort By", "Categories"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.reloadData()
        
        // table view class
        categoriesTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        
        categoriesTableView.registerClass(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: "UITableViewHeaderFooterView")
        
        navigationController!.navigationBar.barTintColor = UIColor(red:0.6, green:0, blue:0, alpha:1.00)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func onSearchButton(sender: UIBarButtonItem) {
        dismissViewControllerAnimated(true, completion: nil)
        
        var filters = [String : AnyObject]()
        
        var selected = [String]()
        for (row,isSelected) in switchStates {
            if (isSelected) {
                selected.append(categories[row]["code"]!)
            }
        }
        
        if (selected.count > 0) {
            filters["categories"] = selected
        }

        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let key = sectionHeaders[section]
        if key == "Categories" {
            return categories.count
        } else {
            return sections[key]!.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let key = sectionHeaders[indexPath.section]
        let row = indexPath.row

        if key == "Categories" {
            let name = categories[row]["name"]
            let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
            cell.categoryLabel.text = categories[row]["name"]
            cell.delegate = self
            let on = switchStates[row] ?? false
            cell.categoryOnSwitch.on = on
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
            cell.textLabel!.text = sections[key]![indexPath.row]
            return cell
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterViewWithIdentifier("UITableViewHeaderFooterView") as! UITableViewHeaderFooterView
        header.textLabel.text = sectionHeaders[section] 
        return header
    }
    
    func categoryTableViewCell(categoryTableViewCell: CategoryTableViewCell, value: Bool) {        
        let indexPath = categoriesTableView.indexPathForCell(categoryTableViewCell)
        switchStates[indexPath!.row] = value
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
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
