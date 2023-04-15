//
//  RepositoriesViewModel.swift
//  mealtime
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class RecipesViewModel {
  var recipes = [RecipeElement]()
  
  let client = SearchRecipesClient()
  
  var query: String
  var cuisines: String
  var dietaryRestrictions: String
  var title: String

  init(query: String = "", cuisines: String = "", dietaryRestrictions: String = "", title: String = "") {
    self.query = query
    self.cuisines = cuisines
    self.dietaryRestrictions = dietaryRestrictions
    self.title = title
  }
  
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
