//
//  recipeTests.swift
//  mealtimeTests
//
//  Created by Kasdan on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import XCTest
@testable import mealtime

class recipeTests: XCTestCase {

//    let valid_recipes_url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=sugar&apiKey=0ff5861766ea48b0a55b2008c47bd778"
//    let invalid_recipes_url = ""
    let client = SearchRecipesClient()
    
    let recipe1 = RecipeElement(id: 1, title: "cake", image: "cake.jpg", imageType: ".jpg", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 3, missedIngredients: [], usedIngredients: [])
    let recipe2 = RecipeElement(id: 2, title: "pizza", image: "pizza.png", imageType: ".png", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 4, missedIngredients: [], usedIngredients: [])
    let recipe3 = RecipeElement(id: 245633, title: "fish", image: "", imageType: "", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 5, missedIngredients: [], usedIngredients: [])
    let recipe4 = RecipeElement(id: nil, title: nil, image: "", imageType: "", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 5, missedIngredients: [], usedIngredients: [])
    
    func test_numberOfRows_valid() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3, recipe4]
        XCTAssert(viewModel.numberOfRows() == 4)
    }
    
    func test_numberOfRows_empty() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = []
        XCTAssert(viewModel.numberOfRows() == 0)
    }
    
    //test for nil title and id
    func test_titleForRowAtIndexPath() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3, recipe4]
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath1), "cake")
        
        let indexPath2 = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath2), "pizza")
        
        let indexPath4 = IndexPath(row: 3, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath4), "Title is nil")
    }
    //test for nil title and id
    func test_idForRowAtIndexPath() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3, recipe4]
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath1), 1)
        let indexPath2 = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath2), 2)
        let indexPath3 = IndexPath(row: 2, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath3), 245633)
        let indexPath4 = IndexPath(row: 3, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath4), -1)
    }
    
    func test_detailViewModelForRowAtIndexPath() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3]
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.detailViewModelForRowAtIndexPath(indexPath1).recipeID, RecipeDetailViewModel(id: recipe1.id!).recipeID)
    }
    
}
