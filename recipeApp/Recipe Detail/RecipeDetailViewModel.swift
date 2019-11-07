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
  
  init(id: Int) {
    self.recipeID = id
  }
  
    
  func refresh(completion: @escaping () -> Void) {
    client.fetchRecipeDetail(inputID: self.recipeID) { [unowned self] recipeDetail in
    
      self.recipeDetail = recipeDetail!
        print(self.recipeDetail!)
      completion()
    }
  }
  
}
