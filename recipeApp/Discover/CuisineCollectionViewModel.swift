//
//  CuisineCollectionViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class CuisineCollectionViewModel {
  var cuisines = [Cuisine]()
    

  func numberOfRows() -> Int? {
    return cuisines.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    
    if let title = cuisines[indexPath.row].title {
        return title
    }
    return "Title is nil"
  }
  
  func cuisinesViewModelForRowAtIndexPath(_ cuisine: Cuisine) -> RecipesViewModel {
    let viewModel = RecipesViewModel(cuisines: cuisine.title!, title: "\(cuisine.title!) Cuisine")
    return viewModel
  }
  
}

