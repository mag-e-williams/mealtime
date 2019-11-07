//
//  GetRecipeDetailClient.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class GetRecipeDetailClient {
  
  func fetchRecipeDetail(inputID: Int,_ completion: @escaping (RecipeDetail?) -> Void) {
    
    let interpString = String(inputID)
    let url = "https://api.spoonacular.com/recipes/\(interpString)/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
    let recipeDetail = getRecipeDetail(url)
    completion(recipeDetail)
    
  }

  func getRecipeDetail(_ url: String) -> RecipeDetail{
    let decoder = JSONDecoder()
    let item = try! decoder.decode(RecipeDetail.self, from: try! Data(contentsOf: URL(string: url)!))
    return item
  }

}
