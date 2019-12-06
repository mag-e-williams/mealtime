//
//  TableViewCell.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//


import UIKit

class TableViewCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    accessoryType = selected ? .checkmark : .none
    selectionStyle = .none
  }
  
}
