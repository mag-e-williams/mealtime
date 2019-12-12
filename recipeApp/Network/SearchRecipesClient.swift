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
    
    let url = "https://api.spoonacular.com/recipes/complexSearch?query=\(interpString)&number=100&apiKey=0ff5861766ea48b0a55b2008c47bd778&instructionsRequired=true&addRecipeInformation=true"

    let recipes = getRecipes(url)
    
    completion(recipes)
  }
  
  func getRecipes(_ url: String) -> [RecipeElement]?{
    let decoder = JSONDecoder()
    let item = try! decoder.decode(Recipes.self, from: try! Data(contentsOf: URL(string: url)!))
    return item.results
  }
  
  
  func fetchSimilarRecipes(inputID: Int,_ completion: @escaping ([RecipeElement]?) -> Void) {
  
    let interpString = String(inputID)
    let url = "https://api.spoonacular.com/recipes/\(interpString)/similar?number=6&apiKey=0ff5861766ea48b0a55b2008c47bd778"
    let recipes = getSimilarRecipes(url)
    completion(recipes)
    
  }
  
  func getSimilarRecipes(_ url: String) -> [RecipeElement]?{
    let decoder = JSONDecoder()
    let item = try! decoder.decode(SimilarRecipes.self, from: try! Data(contentsOf: URL(string: url)!))
//    print("HEREHEE;AWIUEFBAI2U4HT9843")
//    print(item)
    return item
  }
  
  func fetchQuickRecipes(number: Int = 100,_ completion: @escaping ([RecipeElement]?) -> Void) {
    let url = "https://api.spoonacular.com/recipes/complexSearch?maxReadyTime=20&number=20&apiKey=0ff5861766ea48b0a55b2008c47bd778&instructionsRequired=true&addRecipeInformation=true"
     let recipes = getSuggestedRecipes(url)
     completion(recipes)
   }
  
  
  func fetchSuggestedRecipes(number: Int = 100, query: [String] = [""], cuisines: [String] = [""],_ completion: @escaping ([RecipeElement]?) -> Void) {
   
    let queryString = (query.joined(separator:",")).replacingOccurrences(of: " ", with: ",+")
    let cuisineString = (cuisines.joined(separator:",")).replacingOccurrences(of: " ", with: ",+")
    let interpNumber = String(number)
    let url = "https://api.spoonacular.com/recipes/complexSearch?query=\(queryString)&cuisine=\(cuisineString)&number=\(interpNumber)&apiKey=0ff5861766ea48b0a55b2008c47bd778&instructionsRequired=true&addRecipeInformation=true"
     let recipes = getSuggestedRecipes(url)
     completion(recipes)
   }
   
   func getSuggestedRecipes(_ url: String) -> [RecipeElement]?{
     let decoder = JSONDecoder()
     let item = try! decoder.decode(Recipes.self, from: try! Data(contentsOf: URL(string: url)!))
    return item.results
   }
  
  
}
