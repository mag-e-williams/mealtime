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
    
    
  func fetchRecipe(_ entity: String) -> [NSManagedObject]? {
      // Create Fetch Request
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

      do {
          // Execute Fetch Request
          let records = try context.fetch(fetchRequest) as? [NSManagedObject]
          return records
      } catch {
          print("Unable to fetch managed objects for entity \(entity).")
          return nil
      }
  }
    
    func resetData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.reset()
        UserDefaults.standard.set(false, forKey: "TermsAccepted")
    }
    
    
    
  func numberOfIngredientsTableRows() -> Int? {
    return self.recipeIngredients.count
  }
  
  func ingredientTitleForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    return self.recipeIngredients[indexPath.row].name
  }
  
  func ingredientAmountForRowAtIndexPath(_ indexPath: IndexPath) -> String? {
    let amt = rationalApproximationOf(x0: self.recipeIngredients[indexPath.row].amount!)
    let unit = self.recipeIngredients[indexPath.row].unit!
    return String(format: "%@ %@", amt, unit)
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
  
  func refreshDetailByID(recipeID: Int, completion: @escaping () -> Void) {
    client.fetchRecipeDetail(inputID: recipeID) { [unowned self] recipeDetail in
      self.recipeDetail = recipeDetail!
    }
  }
  
}

typealias Rational = (num : Int, den : Int)

func rationalApproximationOf(x0 : Double, withPrecision eps : Double = 1.0E-6) -> String {
    var x = x0
    var a = floor(x)
    var (h1, k1, h, k) = (1, 0, Int(a), 1)

    while x - a > eps * Double(k) * Double(k) {
        x = 1.0/(x - a)
        a = floor(x)
        (h1, k1, h, k) = (h, k, h1 + Int(a) * h, k1 + Int(a) * k)
    }
  if (k == 1) {
    return String(format: "%d", h)
  } else {
    return String(format: "%d/%d", h, k)
  }
  
}
