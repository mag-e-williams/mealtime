//
//  RepositoriesViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class RecipesViewModel {
  var recipes = [RecipeElement]()
  
  let client = SearchRecipesClient()
  
  func numberOfRows() -> Int? {
    return recipes.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
//    return recipes[indexPath.row].title
    return "FUCK"
  }
  
  func refresh(queryString: String, completion: @escaping () -> Void) {
    client.fetchRecipes(inputString: queryString) { [unowned self] recipes in

      self.recipes = recipes!
      completion()
    }
  }
  
}
