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
    
    var switchStates = [Int:Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categoriesTableView.delegate = self
        categoriesTableView.dataSource = self
        categoriesTableView.reloadData()
        
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
        var categories = Business.searchCategories()
        for (row,isSelected) in switchStates {
            println("@@@ \(row)")
            if (isSelected) {
                selected.append(categories[row]["code"]!)
            }
        }
        
        if (selected.count > 0) {
            filters["categories"] = selected
        }
        
        println(filters)
        
        delegate?.filtersViewController?(self, didUpdateFilters: filters)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Business.searchCategories().count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryTableViewCell", forIndexPath: indexPath) as! CategoryTableViewCell
        
        cell.categoryLabel.text = Business.searchCategories()[indexPath.row]["name"]
        cell.delegate = self
        let on = switchStates[indexPath.row] ?? false
        cell.categoryOnSwitch.on = on
        return cell
    }
    
    func categoryTableViewCell(categoryTableViewCell: CategoryTableViewCell, value: Bool) {        
        let indexPath = categoriesTableView.indexPathForCell(categoryTableViewCell)
        switchStates[indexPath!.row] = value
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
