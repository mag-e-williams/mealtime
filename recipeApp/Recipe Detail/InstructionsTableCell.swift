//
//  InstructionsTableCell.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class InstructionsTableCell: UITableViewCell {
  
  @IBOutlet weak var title: UILabel!
  @IBOutlet weak var stepNumber: UILabel!

  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    // Configure the view for the selected state
  }
  
}
