//
//  RecipeCell.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import SDWebImage

class RecipeCell: UICollectionViewCell {

  static let cellID = "RecipeCellID"
  static let cellHeight: CGFloat = 370.0
  static let cellWidth: CGFloat = 360.0

  static let cellPadding: CGFloat = 10.0

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var prepTime: UILabel!
  @IBOutlet var rating: UILabel!

  var recipe: RecipeElement? {
    didSet {
      guard let recipe = recipe else {
        return
      }
      
      let imageURL = URL(string: recipe.image!)
      imageView.sd_setImage(with:imageURL)
      titleLabel.text = recipe.title
        let ratingString : String
        let prepTimeString : String
        if recipe.calories == nil {
            ratingString = "N/A"
        }
        else {
            ratingString = "\(recipe.calories!) cal"
        }
        
        if recipe.readyInMinutes == nil {
            prepTimeString = "N/A"
        }
        else {
            prepTimeString = "\(recipe.readyInMinutes!) min"
        }
      prepTime.text = prepTimeString
      rating.text = ratingString 
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
