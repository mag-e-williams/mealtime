//
//  RecipeDetailViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class RecipeDetailViewModel {
  
  let client = GetRecipeDetailClient()

  var recipeDetail: RecipeDetail?
  var recipeID: Int
  
  var recipeIngredients = [ExtendedIngredient]()
  
  init(id: Int) {
    self.recipeID = id
  }
  
  func numberOfIngredientsTableRows() -> Int? {
    return recipeDetail?.extendedIngredients?.count
  }
  
  func ingredientTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    return self.recipeIngredients[indexPath.row].name
  }
  
  func refresh(completion: @escaping () -> Void) {
    client.fetchRecipeDetail(inputID: self.recipeID) { [unowned self] recipeDetail in
    
      self.recipeDetail = recipeDetail!
      self.recipeIngredients = (self.recipeDetail?.extendedIngredients)!
      print("HEHRHEHRIGA;RBU;GIRUS;I U45G")
      print(self.recipeIngredients.count)
      completion()
    }
  }
  
}
