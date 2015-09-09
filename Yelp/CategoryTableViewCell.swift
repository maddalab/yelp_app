//
//  CategoryTableViewCell.swift
//  Yelp
//
//  Created by Bhaskar Maddala on 9/8/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol CategoryTableViewCellDelegate {
    optional func categoryTableViewCell(categoryTableViewCell: CategoryTableViewCell, value didChangeValue: Bool)
}

class CategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var categoryOnSwitch: UISwitch!
    
    weak var delegate: CategoryTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        categoryOnSwitch.addTarget(self, action: "categorySwitchValueChanged", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func categorySwitchValueChanged() {
        delegate?.categoryTableViewCell?(self, value: categoryOnSwitch.on)
    }

}
