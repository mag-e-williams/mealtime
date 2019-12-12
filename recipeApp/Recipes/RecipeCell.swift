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

  var recipeDetail: RecipeDetail?
  var recipeID: Int?
  
  static let cellPadding: CGFloat = 10.0
  let colorSchemeGreen = UIColor(red: 153, green: 204, blue: 51)
  let lightTextColor = UIColor(red: 164, green: 165, blue: 166)

  @IBOutlet var imageView: UIImageView!
  @IBOutlet var titleLabel: UILabel!
  @IBOutlet var prepTime: UILabel!
  @IBOutlet var rating: UILabel!
  @IBOutlet var savedButton: UIButton!

  var dataViewModel = ProfileViewModel()
  let getRecipeClient = GetRecipeDetailClient()
  var recipeDetailViewModel: RecipeDetailViewModel?
  var savedRecipeIDs = Set<Int>()

  
  var recipe: RecipeElement? {
    didSet {
      guard var recipe = recipe else {
        return
      }
      
        if !recipe.image!.contains("https://spoonacular.com/recipeImages/") {
            recipe.image! = "https://spoonacular.com/recipeImages/" + recipe.image!
      }
      let imageURL = URL(string: recipe.image!)
        
      imageView.sd_setImage(with:imageURL)
      titleLabel.text = recipe.title
      let ratingString : String
      let prepTimeString : String
      if recipe.healthScore == nil {
          ratingString = "N/A"
      }
      else {
          ratingString = "Health Score: \(recipe.healthScore!)"
      }
      
      if recipe.readyInMinutes == nil {
          prepTimeString = "N/A"
      }
      else {
          prepTimeString = "\(recipe.readyInMinutes!) min"
      }
      prepTime.text = prepTimeString
      rating.text = ratingString
      
      let savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()
      if (savedRecipeIDs.contains(recipe.id!)) {
        savedButton.tintColor = colorSchemeGreen
        //      let image = UIImage(named: "heart.fill")
        savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      } else if (!savedRecipeIDs.contains(recipe.id!)) {
        self.savedButton.tintColor = lightTextColor
        self.savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
      }
      self.savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()

      
    }
  }
  
  func updateSavedButton(recipeID: Int) {
    self.savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()
    if (self.savedRecipeIDs.contains(recipeID)) {
      savedButton.tintColor = colorSchemeGreen
      //      let image = UIImage(named: "heart.fill")
      savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
    }else if (!self.savedRecipeIDs.contains(recipeID)) {
      self.savedButton.tintColor = lightTextColor
      self.savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
  
  
//     viewModel.refresh {
//       self.recipeDetail = viewModel.recipeDetail
//       self.loadDetails()
//
//     }

   let client1 = GetRecipeDetailClient()
  @IBAction func saveButtonPressed(_ sender: UIButton) {
    print("pressed save button")
      self.savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()
      
      if let recipe = self.recipe {

        if let id = self.recipe?.id {
            if (!self.savedRecipeIDs.contains(recipe.id!)) {
            print("not already saved")
            self.savedButton.tintColor = colorSchemeGreen
            self.savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
            self.recipeID = id
              
            recipeDetailViewModel = RecipeDetailViewModel(id: id)
            print("right before viewModel")
             if let recipeDetailViewModel = recipeDetailViewModel {
                print("inside if let")
                let url = "https://api.spoonacular.com/recipes/\(id)/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
                self.recipeDetail = client1.getRecipeDetail(url)
//                recipeDetailViewModel.refreshDetailByID(recipeID: id) {
//                  self.recipeDetail = recipeDetailViewModel.recipeDetail
                  print("recipeDetail made")
                print(self.recipeDetail)
                  let appDelegate = UIApplication.shared.delegate as! AppDelegate
                  let context = appDelegate.persistentContainer.viewContext
                  let recipeDetail = self.recipeDetail
                  let newRecipe = self.recipeDetailViewModel!.createRecipe("Recipe")
                    print("saving to coredata")
                  newRecipe?.setValue(recipeDetail?.id, forKey: "id")
                  newRecipe?.setValue(recipeDetail?.title!, forKey: "name")
                  newRecipe?.setValue(recipeDetail?.image!, forKey: "image")
                  newRecipe?.setValue(recipeDetail?.servings!, forKey: "servings")
                  newRecipe?.setValue(recipeDetail?.readyInMinutes!, forKey: "ready_in_minutes")
                  newRecipe?.setValue(recipeDetail?.cheap!, forKey: "cheap")
                  newRecipe?.setValue(recipeDetail?.instructions!, forKey: "instructions")
                    
                  print("new recipe")
                  print(newRecipe!)
                  do {
                    try context.save()
                    print("context was saved")
                  } catch {
                    print("Failed saving")
                  }
                }
            //}
          }
          else if (savedRecipeIDs.contains(recipe.id!)) {
            self.savedButton.tintColor = lightTextColor
            self.savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
            dataViewModel.deleteSingleRecipe(id)
          }
        }
      }
  
  }

  
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}
