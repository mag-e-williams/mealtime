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
//  let parser = RecipesParser()
  
  func numberOfRows() -> Int? {
    return recipes.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    return recipes[indexPath.row].title
  }
  
//  func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> RecipesDetailViewModel {
//    let viewModel = RecipesDetailViewModel(repo: repos[indexPath.row])
//    return viewModel
//  }
//
//  func summaryForRowAtIndexPath(_ indexPath: IndexPath) -> String {
//    return repos[indexPath.row].description
//  }
  
//  func refresh(completion: @escaping () -> Void) {
//    client.fetchRecipes(inputString: <#T##String#>) { [unowned self] data in
//
//      // we need in this block a way for the parser to get an array of repository
//      // objects (if they exist) and then set the repos var in the view model to
//      // those repository objects
//      self.recipes = data!
//      completion()
//    }
//  }
  
}
