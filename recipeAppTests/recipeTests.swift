//
//  recipeTests.swift
//  recipeAppTests
//
//  Created by Kasdan on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import XCTest
@testable import recipeApp

class recipeTests: XCTestCase {

    let valid_recipe_url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=sugar&number=100&apiKey=cc7e79e045f747eabb5362ba580ccac9"
    let invalid_url = ""
    let client = SearchRecipesClient()
    
    
    func testProperRetrieval(){
        
    }

    func testNumberOfRows() {
        let valid_recipe = client.getRecipes(valid_recipe_url)
        
        //VALID URL TESTS
        XCTAssert(valid_recipe.numberOfRows() == 100)
        XCTAssert(valid_recipe[0].title == "Classic Shortbread Cookies")
        
        
        
        //INVALID URL TESTS
        let invalid_recipe: [RecipeElement?] = client.getRecipes(invalid_url)
        XCTAssert(invalid_recipe.count == 0)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    
    func titleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
        return recipes[indexPath.row].title
    }
    
    func idForRowAtIndexPath(_ indexPath: IndexPath) -> Int? {
        return recipes[indexPath.row].id
    }
    
    func detailViewModelForRowAtIndexPath(_ indexPath: IndexPath) -> RecipeDetailViewModel {
        let viewModel = RecipeDetailViewModel(id: recipes[indexPath.row].id)
        return viewModel
    }
    
    func refresh(queryString: String, completion: @escaping () -> Void) {
        client.fetchRecipes(inputString: queryString) { [unowned self] recipes in
            
            self.recipes = recipes!
            completion()
        }
    }

}
