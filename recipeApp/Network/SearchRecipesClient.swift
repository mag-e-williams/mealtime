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
  
    let cleanQuery = (inputString).replacingOccurrences(of: ",", with: "")
    let interpString = (cleanQuery).replacingOccurrences(of: " ", with: ",+")
    
    let url = "https://api.spoonacular.com/recipes/complexSearch?query=\(interpString)&number=10&apiKey=0ff5861766ea48b0a55b2008c47bd778"
    print("url being used")
    print(url)
    let recipes = getRecipes(url)
    
    completion(recipes)
  }
  
  func getRecipes(_ url: String) -> [RecipeElement]?{
    let decoder = JSONDecoder()
    let item = try! decoder.decode(Recipes.self, from: try! Data(contentsOf: URL(string: url)!))
    return item.results
  }
  
}
