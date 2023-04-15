//
//  ProfileViewController.swift
//  mealtime
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//
import UIKit
import Foundation
import CoreData

class ProfileViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    var user: NSManagedObject?
    var viewModel = ProfileViewModel()
    
    var recipeViewModel: RecipeDetailViewModel?
    let recipeCollectionViewModel = RecipeCollectionViewModel()

    let apiClient = SearchRecipesClient()
    var recipes: [AnyObject] = []
    var inProgressTask: Cancellable?
    
    @IBOutlet var usernameInitial: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var savedRecipeCollectionView: UICollectionView!
  
    @IBOutlet var dietaryRestrictionsTable: UITableView!
    @IBOutlet var preferencesTable: UITableView!

    @IBOutlet var dietaryRestrictionsTableHeight: NSLayoutConstraint!
    @IBOutlet var preferencesTableHeight: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
//        viewModel.resetData()
//        viewModel.deleteRecipes()
//        viewModel.deleteUser()
        user = viewModel.fetchUser("User")
        
        let displayName = "\(user?.value(forKey: "first_name") ?? " ")!"
        displayDetails()
        let mySubstring = displayName.prefix(1) // Hello

      self.usernameInitial.text = String(mySubstring)
        
      
        configureCollectionView()
        refreshContent()
      
        let bundle = Bundle(for: type(of: self))

        let dietaryRestrictionsCellNib = UINib(nibName: "TableViewCell", bundle: bundle)
        self.dietaryRestrictionsTable.register(dietaryRestrictionsCellNib, forCellReuseIdentifier: "cell")
      
        let preferencesCellNib = UINib(nibName: "TableViewCell", bundle: bundle)
        self.preferencesTable.register(preferencesCellNib, forCellReuseIdentifier: "cell")
      
        dietaryRestrictionsTableHeight.constant = dietaryRestrictionsTable.contentSize.height
        preferencesTableHeight.constant = preferencesTable.contentSize.height
    }
    
    override func viewDidAppear(_ animated: Bool) {
        configureCollectionView()
        refreshContent()
        dietaryRestrictionsTableHeight.constant = dietaryRestrictionsTable.contentSize.height
        preferencesTableHeight.constant = preferencesTable.contentSize.height
    }
    
    func displayDetails() {
        self.username.text = "   Hi, \(user?.value(forKey: "first_name") ?? "Please Update Your Info")!"
//        self.name = "\(user?.value(forKey: "first_name") ?? "Please Update Your Info")!"
//        self.cuisine.text = "\(user?.value(forKey: "preferences") ?? "No Favorite Cuisines Yet!")"
//        self.restrictions.text = "\(user?.value(forKey: "dietary_restrictions") ?? "No Dietary Restrictions Yet!")"
    }
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == dietaryRestrictionsTable {
          return (viewModel.numberOfDietaryRestrictionTableRows())
        } else if tableView == preferencesTable {
          return (viewModel.numberOfPreferencesTableRows())
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == dietaryRestrictionsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
          cell.title?.text = viewModel.dietaryRestrictionForRowAtIndexPath(indexPath)
            return cell
        } else if tableView == preferencesTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
          cell.title?.text = viewModel.preferenceForRowAtIndexPath(indexPath)
            return cell
        }
        return UITableViewCell()
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
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
        cell.recipe = recipes[indexPath.row] as? RecipeElement
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
      detailVC.viewModel = recipeCollectionViewModel.detailViewModelForRowAtIndexPath(recipe)
    }
//    if segue.identifier == "showAllRecipes" {
//        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
//        showRecipes.query = " "
//    }
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
    
    let recipes = viewModel.createSavedRecipeArray()
    print("the titles")
    for x in recipes{
        print(x.title!)
    }
    self.recipes = recipes as [AnyObject]
    self.savedRecipeCollectionView?.reloadData()
    print(recipes)
      
  }

  func showError() {
  }
}



extension String {
 
    func index(at position: Int, from start: Index? = nil) -> Index? {
        let startingIndex = start ?? startIndex
        return index(startingIndex, offsetBy: position, limitedBy: endIndex)
    }
 
    func character(at position: Int) -> Character? {
        guard position >= 0, let indexPosition = index(at: position) else {
            return nil
        }
        return self[indexPosition]
    }
}
