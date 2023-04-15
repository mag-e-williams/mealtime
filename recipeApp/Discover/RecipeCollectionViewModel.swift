//
//  CollectionViewModel.swift
//  mealtime
//
//  Created by Maggie Williams on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class RecipeCollectionViewModel {
  var recipes = [RecipeElement]()
  
  let client = SearchRecipesClient()
  
  func numberOfRows() -> Int? {
    return recipes.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    
    if let title = recipes[indexPath.row].title{
        return title
    }
    return "Title is nil"
  }
  
  func idForRowAtIndexPath(_ indexPath: IndexPath) -> Int? {
    if let id = recipes[indexPath.row].id{
        return id
    }
    return -1
  }
  
  func detailViewModelForRowAtIndexPath(_ recipe: RecipeElement) -> RecipeDetailViewModel {
    let viewModel = RecipeDetailViewModel(id: recipe.id!)
    return viewModel
  }
  
}
