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
    let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(interpString)&number=100&apiKey=cc7e79e045f747eabb5362ba580ccac9"

    let recipes = getRecipes(url)
    
    completion(recipes)
    
  }
  
  func getRecipes(_ url: String) -> Recipes{
    
    let decoder = JSONDecoder()
    let item = try! decoder.decode(Recipes.self, from: try! Data(contentsOf: URL(string: url)!))
    print(item)
    return item
  }
  
}
