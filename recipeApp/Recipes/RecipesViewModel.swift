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
    
    if let title = recipes[indexPath.row].title{
        return title
    }else{
        return "Title is nil"
    }
  }
  
  func idForRowAtIndexPath(_ indexPath: IndexPath) -> Int? {
    if let id = recipes[indexPath.row].id{
        return id
    }else{
        return -1
    }
  }
  
  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> RecipeDetailViewModel {
    let viewModel = RecipeDetailViewModel(id: recipes[indexPath.row].id!)
    return viewModel
  }
  
  func refresh(queryString: String, completion: @escaping () -> Void) {
    client.fetchRecipes(inputString: queryString) { [unowned self] recipes in

      self.recipes = recipes!
      completion()
    }
  }
  
}