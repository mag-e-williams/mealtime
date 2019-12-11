//
//  ProfileViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    var user: NSManagedObject?
    var viewModel = ProfileViewModel()
    
    var recipeViewModel: RecipeDetailViewModel?

    
    
    @IBOutlet var username: UILabel!
    @IBOutlet var cuisine: UILabel!
    @IBOutlet var restrictions: UILabel!
    @IBOutlet var saved_recipes: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.resetData()
//        deleteRecipes()
        user = viewModel.fetchUser("User")
        displayDetails()
        displayRecipes()
//        let _ = createSavedRecipeArray()
    }
    
    func displayDetails() {
        self.username.text = "Hi, \(user!.value(forKey: "first_name")!)!"
        self.cuisine.text = "\(user!.value(forKey: "preferences")!)"
        self.restrictions.text = "\(user!.value(forKey: "dietary_restrictions")!)" 
    }
    
    func loadRecipes() -> Set<Int> {
        let recipeViewModel = RecipeDetailViewModel(id: 1)  
        var recipeSet = Set<Int>()
        guard let recipes = recipeViewModel.fetchRecipe("Recipe") else { return [] }
        for recipe in recipes {
            let recipeID = (recipe.value(forKey: "id")! as AnyObject).integerValue
            recipeSet.insert(recipeID!)
        }
        return recipeSet
    }
    
    func displayRecipes() {  
        var recipe_string = ""
        let recipeSet = loadRecipes()
        for x in recipeSet {
            recipe_string += "\(x)\n"
        }
        self.saved_recipes.text = recipe_string
    }
    
    
    let client = GetRecipeDetailClient()
    func createSavedRecipeArray() -> [RecipeDetail] {
        let recipeSet = loadRecipes()
        var recipeElements : [RecipeDetail] = []
        for recipeID in recipeSet {
            let url = "https://api.spoonacular.com/recipes/\(recipeID)/information?includeNutrition=false&apiKey=0ff5861766ea48b0a55b2008c47bd778"
            let recipeDetail = client.getRecipeDetail(url)
            recipeElements.append(recipeDetail)
        }
        print("profile stuff")
        print(recipeElements)
        return recipeElements
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
