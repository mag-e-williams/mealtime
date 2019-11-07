//
//  SearchRecipesClient.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class SearchRecipesClient {
  
  
  func fetchRecipes(inputString: String,_ completion: @escaping ([RecipeElement]?) -> Void) {
  
    let cleanQuery = (inputString).replacingOccurrences(of: " ", with: "")
    let interpString = (cleanQuery).replacingOccurrences(of: ",", with: ",+")
    let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(interpString)&number=30&apiKey=0ff5861766ea48b0a55b2008c47bd778"

    let recipes = queryAPI(url)
    
    completion(recipes)
    
  }
  
}
