//
//  FilterViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation
import UIKit

class FilterViewModel:NSObject {
  var filters = [Filter]()

  func numberOfRows() -> Int? {
    return filters.count
  }
  
  var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
    didSet {
      didToggleSelection?(!selectedFilters.isEmpty)
    }
  }
  
  var selectedFilters: [Filter] {
    get {
      return filters.filter { return $0.isSelected! }
    }
  }
  
  override init() {
    super.init()
    filters = Filters().getFilters()
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    if let title = filters[indexPath.row].title{
        return title
    }
    return "Title is nil"
  }
  
  func refresh() {
    filters = Filters().getFilters()
  }
    
    
    func filterOutCuisines(_ recipes: [RecipeElement]) -> [RecipeElement] {
        let userViewModel = ProfileViewModel()
        let user = userViewModel.fetchUser("User")
        let filterString : String
        var filteredList : [RecipeElement] = []
        
        
        if user!.value(forKey: "filters") == nil {
            filterString = ""
        }
        else{
            filterString = user!.value(forKey: "filters") as! String
        }
        let filterArray = filterString.split { String($0) == "," }
        
        if filterArray == [] {
            return recipes
        }
        for recipe in recipes {
            for cuisine in recipe.cuisines! {
                if filterArray.contains(Substring(cuisine)) {
                    print("appended")
                    filteredList.append(recipe)
                }
            }
        }
        
        return filteredList
    }

}
