//
//  getRecipesCallTests.swift
//  recipeAppTests
//
//  Created by Kasdan on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import XCTest
@testable import recipeApp

class searchRecipesCallTests: XCTestCase {
    
    let client = SearchRecipesClient()
    let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=sugar&apiKey=cc7e79e045f747eabb5362ba580ccac9"

    func test_getRecipes() {
//        let decoder = JSONDecoder()
//        let data = loadJSONTestData("validRecipes")
//        let pulled_data = client.getRecipes(url)
    }
    
    
    func loadJSONTestData(_ filename: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
}
