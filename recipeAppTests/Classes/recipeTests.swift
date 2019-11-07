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

//    let valid_recipes_url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=sugar&apiKey=cc7e79e045f747eabb5362ba580ccac9"
//    let invalid_recipes_url = ""
    let client = SearchRecipesClient()
    
    let recipe1 = RecipeElement(id: 1, title: "cake", image: "cake.jpg", imageType: ".jpg", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 3, missedIngredients: [], usedIngredients: [])
    let recipe2 = RecipeElement(id: 2, title: "pizza", image: "pizza.png", imageType: ".png", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 4, missedIngredients: [], usedIngredients: [])
    let recipe3 = RecipeElement(id: 245633, title: "fish", image: "", imageType: "", usedIngredientCount: 0, missedIngredientCount: 0, unusedIngredients: [], likes: 5, missedIngredients: [], usedIngredients: [])
    
    //VALID URL TESTS
    func test_numberOfRows_valid() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3]
        XCTAssert(viewModel.numberOfRows() == 3)
    }
    
    func test_numberOfRows_empty() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = []
        XCTAssert(viewModel.numberOfRows() == 0)
    }
    
    
    func test_titleForRowAtIndexPath() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3]
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath1), "cake")
        
        let indexPath2 = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.titleForRowAtIndexPath(indexPath2), "pizza")
    }
    
    func test_idForRowAtIndexPath() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3]
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath1), 1)
        let indexPath2 = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath2), 2)
        let indexPath3 = IndexPath(row: 2, section: 0)
        XCTAssertEqual(viewModel.idForRowAtIndexPath(indexPath3), 245633)
    }
    
    func test_detailViewModelForRowAtIndexPath() {
        let viewModel = RecipesViewModel()
        viewModel.recipes = [recipe1, recipe2, recipe3]
        
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.detailViewModelForRowAtIndexPath(indexPath1).recipeID, RecipeDetailViewModel(id: recipe1.id).recipeID)
    }

}
