//
//  recipeDetailTests.swift
//  recipeAppTests
//
//  Created by Kasdan on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import XCTest
@testable import recipeApp

class recipeDetailTests: XCTestCase {

    let valid_url = "https://api.spoonacular.com/recipes/716429/information?includeNutrition=false&apiKey=cc7e79e045f747eabb5362ba580ccac9"
    let invalid_url = ""
    let client = SearchRecipesClient()
    
    
    func test_recipeDetail_init(){
        let viewModel = RecipeDetailViewModel(id: 1)
        XCTAssert(viewModel.recipeID == 1)
    }
    
    func test_information_access(){
//        let data = loadJSONTestData("validRecipeDetail")
//        let results = parser.parseDictionary(data)
        
//        XCTAssertNotNil(results)
//        XCTAssertEqual(87367, results!["total_count"] as? Int)
    }
    
    func loadJSONTestData(_ filename: String) -> Data? {
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: filename, ofType: "json")
        return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
    }
}
