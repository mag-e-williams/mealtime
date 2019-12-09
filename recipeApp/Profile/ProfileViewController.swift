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
////        print("")
////        print("is it saved")
////        print(user!.value(forKey: "first_name")!)
////        print(user!.value(forKey: "last_name")!)
////        print(user!.value(forKey: "email")!)
////        print(user!.value(forKey: "preferences")!)
////        print(user!.value(forKey: "dietary_restrictions")!)
        loadDetails()
        loadRecipes()
    }
    
    func loadDetails() {
        print("user is")
        print(user!)
        self.username.text = "Hi, \(user!.value(forKey: "first_name")!)!"
        self.cuisine.text = "\(user!.value(forKey: "preferences")!)"
        self.restrictions.text = "\(user!.value(forKey: "dietary_restrictions")!)" 
    }
    
    func loadRecipes() {
        let recipeViewModel = RecipeDetailViewModel(id: 1)  
        var recipe_string = ""
        guard let recipes = recipeViewModel.fetchRecipe("Recipe") else { return }
        for recipe in recipes {
            print("the IDs")
            print(recipe.value(forKey: "id")!)
            recipe_string += "\(recipe.value(forKey: "id")!)\n"
        }
        self.saved_recipes.text = recipe_string
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
