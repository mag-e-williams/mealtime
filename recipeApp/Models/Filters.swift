//
//  Cuisines.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//


import UIKit

struct Filter: Codable {
  let title: String?
}

class Filters {
  var data = [
  Filter(title: "African"),
  Filter(title: "American"),
  Filter(title: "British"),
  Filter(title: "Cajun"),
  Filter(title: "Caribbean"),
  Filter(title: "Chinese"),
  Filter(title: "Eastern European"),
  Filter(title: "European"),
  Filter(title: "French"),
  Filter(title: "German"),
  Filter(title: "Greek"),
  Filter(title: "Indian"),
  Filter(title: "Irish"),
  Filter(title: "Italian"),
  Filter(title: "Japanese"),
  Filter(title: "Jewish"),
  Filter(title: "Korean"),
  Filter(title: "Latin American"),
  Filter(title: "Mediterranean"),
  Filter(title: "Mexican"),
  Filter(title: "Middle Eastern"),
  Filter(title: "Nordic"),
  Filter(title: "Southern"),
  Filter(title: "Spanish"),
  Filter(title: "Thai"),
  Filter(title: "Vietnamese"),
  ]
  
  func getFilters() -> [Filter] {
    return data
  }
  
  func getCuisines() -> [Filter] {
    return data
  }
  
}

