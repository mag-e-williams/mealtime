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

class ProfileViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var user: NSManagedObject?
    var viewModel = ProfileViewModel()
    
    var recipeViewModel: RecipeDetailViewModel?
    let recipeViewModelCollection = RecipeCollectionViewModel()

    let apiClient = SearchRecipesClient()
    var recipes: [RecipeDetail] = []
    var inProgressTask: Cancellable?
    
    @IBOutlet var username: UILabel!
    @IBOutlet var cuisine: UILabel!
    @IBOutlet var restrictions: UILabel!
    @IBOutlet var saved_recipes: UILabel!
    @IBOutlet var savedRecipeCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("what")
//        viewModel.resetData()
//        deleteRecipes()
//        user = viewModel.fetchUser("User")
//        print("loaded users")
//        displayDetails()
        print("displayed details")
//        displayRecipes()
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


//MARK: SAVED RECIPES DISPLAY CODE


// MARK: UI Configuration
extension ProfileViewController {
  func configureCollectionView() {
    let savedCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    savedRecipeCollectionView?.register(savedCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
  }
}


// MARK: UICollectionViewDelegateFlowLayout
extension ProfileViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == savedRecipeCollectionView {
      return CGSize(width: view.bounds.width - (RecipeCell.cellPadding * 2), height: RecipeCell.cellHeight)
    }
    return CGSize()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView == savedRecipeCollectionView {
      return UIEdgeInsets(top: RecipeCell.cellPadding, left: RecipeCell.cellPadding, bottom: RecipeCell.cellPadding, right: RecipeCell.cellPadding)
    }
    
    return UIEdgeInsets()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == savedRecipeCollectionView {
      return RecipeCell.cellPadding
    }
    return 0.0
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}



// MARK: UICollectionViewDataSource and Delegate
extension ProfileViewController {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == savedRecipeCollectionView {
      return recipes.count
    }
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == savedRecipeCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SavedCell.cellID, for: indexPath) as? SavedCell {
        cell.recipe = recipes[indexPath.row]
        return cell
      } else {
        fatalError("Missing cell for indexPath: \(indexPath)")
      }
    }
    
    return UICollectionViewCell()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RecipeDetailViewController,
      let recipe = sender as? RecipeElement {
      detailVC.viewModel = recipeViewModelCollection.detailViewModelForRowAtIndexPath(recipe)
    }
    if segue.identifier == "showAllRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.query = " "
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == savedRecipeCollectionView {
      let recipe = recipes[indexPath.row]
      performSegue(withIdentifier: "toDetailVC", sender: recipe)
    }
  }
}

//TODO
// MARK: Data
extension ProfileViewController {

  func refreshContent() {
    guard inProgressTask == nil else {
      inProgressTask?.cancel()
      inProgressTask = nil
      return
    }
    let recipes = createSavedRecipeArray()
    self.recipes = recipes
    self.savedRecipeCollectionView?.reloadData()
    }
      
  }

  func showError() {

  }



