//
//  RecipeCell.swift
//  recipeApp
//
//  Created by Kasdan on 12/11/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import SDWebImage

class SavedCell: UICollectionViewCell {

  static let cellID = "SavedCellID"
  static let cellHeight: CGFloat = 370.0
  static let cellWidth: CGFloat = 360.0

  static let cellPadding: CGFloat = 8.0

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!

  var recipe: RecipeDetail? {
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
