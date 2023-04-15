//
//  getRecipeDetailsCallTests.swift
//  mealtimeTests
//
//  Created by Kasdan on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import XCTest
@testable import mealtime

class getRecipeDetailsCallTests: XCTestCase {
    let client = GetRecipeDetailClient()
    let recipeDetail = RecipeDetail.self
    let url = "https://api.spoonacular.com/recipes/716429/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"

    func test_getRecipeDetails() {
        
    }

}
