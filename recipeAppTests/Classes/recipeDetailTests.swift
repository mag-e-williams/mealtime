//
//  recipeDetailTests.swift
//  mealtimeTests
//
//  Created by Kasdan on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import XCTest
@testable import mealtime

class recipeDetailTests: XCTestCase {

    let url = "https://api.spoonacular.com/recipes/716429/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
    let url_instructions = "https://api.spoonacular.com/recipes/716429/analyzedInstructions?apiKey=0ff5861766ea48b0a55b2008c47bd778"
    let url1 = "https://api.spoonacular.com/recipes/1059776/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
    let url1_instructions = "https://api.spoonacular.com/recipes/1059776/analyzedInstructions?apiKey=0ff5861766ea48b0a55b2008c47bd778"
    let client = GetRecipeDetailClient()
    let recipeDetail = RecipeDetail.self
    
    
    
    func test_init() {
        let recipeDetail = client.getRecipeDetail(url)
        let viewModel = RecipeDetailViewModel(id: recipeDetail.id!)
        XCTAssertEqual(viewModel.recipeID, 716429)
    }
    
    func test_numberOfIngredientsTableRows() {
        let recipeDetail = client.getRecipeDetail(url)
        let viewModel = RecipeDetailViewModel(id: recipeDetail.id!)
        viewModel.recipeIngredients = recipeDetail.extendedIngredients!
        XCTAssertEqual(viewModel.numberOfIngredientsTableRows(), 11)
    }
    
    
    
    func test_ingredientTitleForRowAtIndexPath() {
        let recipeDetail = client.getRecipeDetail(url)
        let viewModel = RecipeDetailViewModel(id: recipeDetail.id!)
        viewModel.recipeIngredients = recipeDetail.extendedIngredients!

        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.ingredientTitleForRowAtIndexPath(indexPath1), "butter")
        let indexPath2 = IndexPath(row: 1, section: 0)
        XCTAssertEqual(viewModel.ingredientTitleForRowAtIndexPath(indexPath2), "cauliflower florets")
    }

    
    func test_numberOfInstructionTableRows() {
        let recipeDetail = client.getRecipeDetail(url)
        let viewModel = RecipeDetailViewModel(id: recipeDetail.id!)
        viewModel.recipeInstructions = client.getRecipeInstructions(url_instructions)
        XCTAssertEqual(viewModel.recipeInstructions.count, 0)
        XCTAssertEqual(viewModel.numberOfInstructionTableRows(), 0)
        
        
        let recipeDetail1 = client.getRecipeDetail(url1)
        let viewModel1 = RecipeDetailViewModel(id: recipeDetail1.id!)
        viewModel1.recipeInstructions = client.getRecipeInstructions(url1_instructions)
        viewModel1.recipeInstructionSteps = viewModel1.recipeInstructions[0].steps
        XCTAssertEqual(viewModel1.numberOfInstructionTableRows(), 6)
    }
    
    func test_instructionForRowAtIndexPath() {
        let recipeDetail = client.getRecipeDetail(url)
        let viewModel = RecipeDetailViewModel(id: recipeDetail.id!)
        viewModel.recipeInstructions = client.getRecipeInstructions(url_instructions)
//        viewModel.recipeInstructionSteps = viewModel.recipeInstructions[0].steps
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.instructionForRowAtIndexPath(indexPath1), "No instructions to display")
        
        let recipeDetail1 = client.getRecipeDetail(url1)
        let viewModel1 = RecipeDetailViewModel(id: recipeDetail1.id!)
        viewModel1.recipeInstructions = client.getRecipeInstructions(url1_instructions)
        viewModel1.recipeInstructionSteps = viewModel1.recipeInstructions[0].steps
        let indexPath2 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel1.instructionForRowAtIndexPath(indexPath2), "Preheat oven to 325 F degrees.")
    }
    
    func test_instructionNumberForRowAtIndexPath() {
        let recipeDetail = client.getRecipeDetail(url)
        let viewModel = RecipeDetailViewModel(id: recipeDetail.id!)
        viewModel.recipeInstructions = client.getRecipeInstructions(url_instructions)
//        viewModel.recipeInstructionSteps = viewModel.recipeInstructions[0].steps
        let indexPath1 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel.instructionNumberForRowAtIndexPath(indexPath1), "N/A")
        
        
        let recipeDetail1 = client.getRecipeDetail(url1)
        let viewModel1 = RecipeDetailViewModel(id: recipeDetail1.id!)
        viewModel1.recipeInstructions = client.getRecipeInstructions(url1_instructions)
        viewModel1.recipeInstructionSteps = viewModel1.recipeInstructions[0].steps
        let indexPath2 = IndexPath(row: 0, section: 0)
        XCTAssertEqual(viewModel1.instructionNumberForRowAtIndexPath(indexPath2), "1")
    }
    
    
    //test that api returns proper information for detail
    //test that api returns proper information for analyzed instructions
    
    
}
