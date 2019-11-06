//
//  SearchRecipesClient.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class SearchRecipesClient {
  
  var recipes = [RecipeElement]()
  
  func fetchRecipes(_ completion: @escaping (Data?) -> Void, ingredientInput: String) {
  
    let cleanQuery = (ingredientInput).replacingOccurrences(of: " ", with: "")
    let interpString = (cleanQuery).replacingOccurrences(of: ",", with: ",+")
    let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(interpString)&apiKey=0ff5861766ea48b0a55b2008c47bd778"

    recipes = queryAPI(url)
  }
  
}
