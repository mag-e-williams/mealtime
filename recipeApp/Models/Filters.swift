//
//  Cuisines.swift
//  mealtime
//
//  Created by Maggie Williams on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//


import UIKit

struct Filter: Codable {
  var title: String?
  var isSelected: Bool?
}

class Filters {
  var data = [
    Filter(title: "African", isSelected: false),
    Filter(title: "American", isSelected: false),
    Filter(title: "British", isSelected: false),
    Filter(title: "Cajun", isSelected: false),
    Filter(title: "Caribbean", isSelected: false),
    Filter(title: "Chinese", isSelected: false),
    Filter(title: "Eastern European", isSelected: false),
    Filter(title: "European", isSelected: false),
    Filter(title: "French", isSelected: false),
    Filter(title: "German", isSelected: false),
    Filter(title: "Greek", isSelected: false),
    Filter(title: "Indian", isSelected: false),
    Filter(title: "Irish", isSelected: false),
    Filter(title: "Italian", isSelected: false),
    Filter(title: "Japanese", isSelected: false),
    Filter(title: "Jewish", isSelected: false),
    Filter(title: "Korean", isSelected: false),
    Filter(title: "Latin American", isSelected: false),
    Filter(title: "Mediterranean", isSelected: false),
    Filter(title: "Mexican", isSelected: false),
    Filter(title: "Middle Eastern", isSelected: false),
    Filter(title: "Nordic", isSelected: false),
    Filter(title: "Southern", isSelected: false),
    Filter(title: "Spanish", isSelected: false),
    Filter(title: "Thai", isSelected: false),
    Filter(title: "Vietnamese", isSelected: false),
  ]
  
  func getFilters() -> [Filter] {
    return data
  }
  
  func getCuisines() -> [Filter] {
    return data
  }
  
}

