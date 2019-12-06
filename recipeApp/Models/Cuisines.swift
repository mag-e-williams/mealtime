//
//  Cuisines.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//


import UIKit

struct Cuisine: Codable {
  let title: String
}

struct Cuisines: Codable {
  let cuisines = [
  Cuisine(title: "African"),
  Cuisine(title: "American"),
  Cuisine(title: "British"),
  Cuisine(title: "Cajun"),
  Cuisine(title: "Caribbean"),
  Cuisine(title: "Chinese"),
  Cuisine(title: "Eastern European"),
  Cuisine(title: "European"),
  Cuisine(title: "French"),
  Cuisine(title: "German"),
  Cuisine(title: "Greek"),
  Cuisine(title: "Indian"),
  Cuisine(title: "Irish"),
  Cuisine(title: "Italian"),
  Cuisine(title: "Japanese"),
  Cuisine(title: "Jewish"),
  Cuisine(title: "Korean"),
  Cuisine(title: "Latin American"),
  Cuisine(title: "Mediterranean"),
  Cuisine(title: "Mexican"),
  Cuisine(title: "Middle Eastern"),
  Cuisine(title: "Nordic"),
  Cuisine(title: "Southern"),
  Cuisine(title: "Spanish"),
  Cuisine(title: "Thai"),
  Cuisine(title: "Vietnamese"),
  ]
  
}

