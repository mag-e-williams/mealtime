//
//  ProfileViewModel.swift
//  recipeApp
//
//  Created by Kasdan on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class ProfileViewModel {
  
    func numberOfDietaryRestrictionTableRows() -> Int {
      let str = getDietaryRestrictions()
      let array = str.components(separatedBy: ",")
      return array.count
    }
  
    func numberOfPreferencesTableRows() -> Int {
      let str = getCuisinePreferences()
      let array = str.components(separatedBy: ",")
      return array.count
    }

    func dietaryRestrictionForRowAtIndexPath(_ indexPath: IndexPath) -> String {
      let str = getDietaryRestrictions()
      let array = str.components(separatedBy: ",")
      return array[indexPath.row]
    }
  
    func preferenceForRowAtIndexPath(_ indexPath: IndexPath) -> String {
      let str = getCuisinePreferences()
      let array = str.components(separatedBy: ",")
      return array[indexPath.row]
    }
    
    func createUser(_ entity: String) -> NSManagedObject? {
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
    
    func fetchUser(_ entity: String) -> NSManagedObject? {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        // Helpers
        var result = NSManagedObject()

        do {
            // Execute Fetch Request
            let records = try context.fetch(fetchRequest)
            print(records)
            if let records = records as? [NSManagedObject?] {
                if records == [] {
                    print("the user is nil")
                    let newUser = createUser("User")
                    return newUser
//                    return nil
                }
                result = records[0]!
                print(result)
                print(records)
                return records[0]
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
            return nil
        }

        return result
    }
    
    func profileLoadSavedRecipes() -> Set<Int> {
        let recipeViewModel = RecipeDetailViewModel(id: 1)  
        var recipeSet = Set<Int>()
        guard let recipes = recipeViewModel.fetchRecipe("Recipe") else { return [] }
        for recipe in recipes {
//            print("y r u crashing")
//            print(recipe)
            let recipeID = (recipe.value(forKey: "id")! as AnyObject).integerValue
            recipeSet.insert(recipeID!)
        }
        return recipeSet
    }
  
    func getCuisinePreferences() -> String {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let user = fetchUser("User")
      if user?.value(forKey: "preferences") == nil || user?.value(forKey: "preferences") as? String == "" {
        return "sugar,christmas"
      } else {
        return user?.value(forKey: "preferences") as! String
      }
    }
  
    func getDietaryRestrictions() -> String {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      let context = appDelegate.persistentContainer.viewContext
      let user = fetchUser("User")
      if user?.value(forKey: "dietary_restrictions") == nil || user?.value(forKey: "dietary_restrictions") as? String == "" {
        return ""
      } else {
        return user?.value(forKey: "dietary_restrictions") as! String
      }
    }
  
    let client = GetRecipeDetailClient()
    let client1 = SearchRecipesClient() 
    func createSavedRecipeArray() -> [RecipeElement] {
        let recipeSet = profileLoadSavedRecipes()
        var recipeElements : [RecipeElement] = []
        for recipeID in recipeSet {
            let url = "https://api.spoonacular.com/recipes/\(recipeID)/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
            let dummyURL = "https://api.spoonacular.com/recipes/complexSearch?query=cheese&number=1&apiKey=0ff5861766ea48b0a55b2008c47bd778&instructionsRequired=true&addRecipeInformation=true"
            let recipeDetail = client.getRecipeDetail(url)
            var dummyRecipeElement = client1.getRecipes(dummyURL)
            
            dummyRecipeElement![0].id = recipeDetail.id
            dummyRecipeElement![0].title = recipeDetail.title
            dummyRecipeElement![0].calories = recipeDetail.healthScore
            dummyRecipeElement![0].image = recipeDetail.image
            dummyRecipeElement![0].imageType = recipeDetail.imageType
            dummyRecipeElement![0].readyInMinutes = recipeDetail.readyInMinutes
            dummyRecipeElement![0].cookingMinutes = -1
            dummyRecipeElement![0].diets = []
            dummyRecipeElement![0].cuisines = []
            
            recipeElements.append(dummyRecipeElement![0])
        }
        return recipeElements
    }
    
    func resetData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        context.reset()
        UserDefaults.standard.set(false, forKey: "TermsAccepted")
        appDelegate.saveContext()
    }
    
    func deleteUser() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let user = fetchUser("User")
        context.delete(user!)
        appDelegate.saveContext()
    }
    
    let recipeViewModel = RecipeDetailViewModel(id: 1)
    func saveRecipeByID(_ id: Int) {
        let recipeViewModel = RecipeDetailViewModel(id: 1)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let url = "https://api.spoonacular.com/recipes/\(id)/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
        let recipe = client.getRecipeDetail(url)
        let newRecipe = recipeViewModel.createRecipe("Recipe")

        newRecipe?.setValue(recipe.id!, forKey: "id")
        newRecipe?.setValue(recipe.title!, forKey: "name")
        newRecipe?.setValue(recipe.image!, forKey: "image")
        newRecipe?.setValue(recipe.servings!, forKey: "servings")
        newRecipe?.setValue(recipe.readyInMinutes!, forKey: "ready_in_minutes")
        newRecipe?.setValue(recipe.cheap!, forKey: "cheap")
        newRecipe?.setValue(recipe.instructions!, forKey: "instructions")
        
//        print("new recipe")
//        print(newRecipe!)
        do {
            try context.save()
//            print("context was saved")
        } catch {
            print("Failed saving")
        }
    }
    
    
    func deleteSingleRecipe(_ id: Int) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let recipes = recipeViewModel.fetchRecipe("Recipe")
        for recipe in recipes! {
            if recipe.value(forKey: "id") as? Int == id {
                context.delete(recipe)
            }
        }
        appDelegate.saveContext()
    }
    
    
    func deleteRecipes() {
        let recipeViewModel = RecipeDetailViewModel(id: 1)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let recipes = recipeViewModel.fetchRecipe("Recipe")
        for recipe in recipes! {
            context.delete(recipe)
        }
        appDelegate.saveContext()
    }
}
