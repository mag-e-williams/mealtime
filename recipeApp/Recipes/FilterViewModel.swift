//
//  FilterViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class FilterViewModel {
  var filters = [Filter]()
    
  func numberOfRows() -> Int? {
    return filters.count
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    if let title = filters[indexPath.row].title{
        print(title)
        return title
    }
    return "Title is nil"
  }
  func refreshContent() {
    
  }
  
}
