//
//  FilterViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class FilterViewModel:NSObject {
  var filters = [Filter]()
//  var selectedFilters = [Filter]()

  func numberOfRows() -> Int? {
    return filters.count
  }
  
  var didToggleSelection: ((_ hasSelection: Bool) -> ())? {
    didSet {
      didToggleSelection?(!selectedFilters.isEmpty)
    }
  }
  
  var selectedFilters: [Filter] {
    return filters.filter { return $0.isSelected! }
  }
  
  override init() {
    super.init()
    filters = Filters().getFilters()
    
  }
  
  func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    if let title = filters[indexPath.row].title{
        print(title)
        return title
    }
    return "Title is nil"
  }
  
  func refresh() {
    filters = Filters().getFilters()
  }

}
