//
//  RecipeDetailViewModel.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation
import CoreData
import UIKit

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
  
  func createRecipe(_ entity: String) -> NSManagedObject? {
      // Helpers
      var result: NSManagedObject?
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      // Create Entity Description
      let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: context)
      if let entityDescription = entityDescription {
          // Create Managed Object
          result = NSManagedObject(entity: entityDescription, insertInto: context)
      }
      return result
  }
    
    
  func fetchRecipe(_ entity: String) -> NSManagedObject? {
      // Create Fetch Request
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

      // Helpers
      var result = NSManagedObject()

      do {
          // Execute Fetch Request
          let records = try context.fetch(fetchRequest)
          if let records = records[0] as? NSManagedObject {
              result = records
              print(result)
          }

      } catch {
          print("Unable to fetch managed objects for entity \(entity).")
      }

      return result
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
    if(self.numberOfInstructionTableRows() == 0){
        return "No instructions to display"
    }
    return self.recipeInstructionSteps[indexPath.row].step
  }
  
  func instructionNumberForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    if(self.numberOfInstructionTableRows() == 0){
        return "N/A"
    }
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
