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

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
