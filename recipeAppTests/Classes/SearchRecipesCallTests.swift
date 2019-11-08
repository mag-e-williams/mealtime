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
    let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=sugar&apiKey=0ff5861766ea48b0a55b2008c47bd778"

    func test_getRecipes() {
        let recipes = client.getRecipes(url)
        XCTAssertEqual(recipes.count, 10)
        XCTAssertEqual(recipes[0].title, "Classic Shortbread Cookies")
        XCTAssertEqual(recipes[0].id, 1059776)
    }
    
//    func refresh(queryString: String, completion: @escaping () -> Void) {
//        client.fetchRecipes(inputString: queryString) { [unowned self] recipes in
//            
//            self.recipes = recipes!
//            completion()
//        }
//    }
    
    
    func test_fetchRecipes() {
        //TEST FETCH_RECIPES
    }
    
}
