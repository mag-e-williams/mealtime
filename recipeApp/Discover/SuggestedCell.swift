//
//  RecipeCell.swift
//  mealtime
//
//  Created by Maggie Williams on 12/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import SDWebImage

class SuggestedCell: UICollectionViewCell {

  static let cellID = "SuggestedCellID"
  static let cellHeight: CGFloat = 370.0
  static let cellWidth: CGFloat = 360.0

  static let cellPadding: CGFloat = 8.0

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!

  var recipe: RecipeElement? {
    didSet {
      guard let recipe = recipe else {
        return
      }
      
      let imageURL = URL(string: recipe.image!)
      imageView.sd_setImage(with:imageURL)
      titleLabel.text = recipe.title
      
    }
  }

  override func awakeFromNib() {
    super.awakeFromNib()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    
    imageView.sd_cancelCurrentImageLoad()
    titleLabel.text = nil
  }

}
