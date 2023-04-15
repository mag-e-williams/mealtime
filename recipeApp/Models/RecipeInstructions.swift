//
//  RecipeInstructions.swift
//  mealtime
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

// MARK: - RecipeInstruction
struct RecipeInstruction: Codable {
  let name: String
  let steps: [Step]
}

// MARK: - Step
struct Step: Codable {
  let equipment, ingredients: [Ent]
  let number: Int
  let step: String
  let length: Length?
}

// MARK: - Ent
struct Ent: Codable {
  let id: Int
  let image, name: String
  let temperature: Length?
}

// MARK: - Length
struct Length: Codable {
  let number: Int
  let unit: String
}

typealias RecipeInstructions = [RecipeInstruction]
