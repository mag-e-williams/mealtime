//
//  RecipeDetailViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation

class RecipeDetailViewModel {
  
  let client = GetRecipeDetailClient()

  var recipeDetail: RecipeDetail?
  var recipeID: Int
  
  var recipeIngredients = [ExtendedIngredient]()
  var recipeInstructions = [RecipeInstruction]()
  var recipeInstructionSteps = [Step]()

  init(id: Int) {
    self.recipeID = id
  }
  
  func numberOfIngredientsTableRows() -> Int? {
    return self.recipeIngredients.count
//    return self.recipeDetail?.extendedIngredients?.count
  }
  
  func ingredientTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    return self.recipeIngredients[indexPath.row].name
  }
  
  func numberOfInstructionTableRows() -> Int? {
    return self.recipeInstructionSteps.count
  }
  
  func instructionForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    return self.recipeInstructionSteps[indexPath.row].step
  }
  
  func instructionNumberForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    return String(self.recipeInstructionSteps[indexPath.row].number)
  }
  
  func refresh(completion: @escaping () -> Void) {
    client.fetchRecipeDetail(inputID: self.recipeID) { [unowned self] recipeDetail in
      self.recipeDetail = recipeDetail!
      self.recipeIngredients = (self.recipeDetail?.extendedIngredients)!
      completion()
    }
    
    client.fetchRecipeInstructions(inputID: self.recipeID) { [unowned self] recipeInstructions in
      self.recipeInstructions = recipeInstructions!
      self.recipeInstructionSteps = self.recipeInstructions[0].steps
      completion()
    }
    
  }
  
}
