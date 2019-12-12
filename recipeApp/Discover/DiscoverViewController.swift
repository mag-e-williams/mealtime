//
//  DiscoverViewController.swift
//  recipeApp
//
//  Created by Maggie on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.


import UIKit


class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
  
  @IBOutlet var searchBar: UISearchBar!

  @IBOutlet var cuisineCollectionView: UICollectionView!

  @IBOutlet var suggestedCollectionView: UICollectionView!
  @IBOutlet var quickCollectionView: UICollectionView!
  @IBOutlet var veganCollectionView: UICollectionView!
  @IBOutlet var vegetarianCollectionView: UICollectionView!
  @IBOutlet var saladsCollectionView: UICollectionView!
  @IBOutlet var stirFryCollectionView: UICollectionView!
  @IBOutlet var dessertsCollectionView: UICollectionView!

  
  @IBOutlet var seeAllSuggestedButton: UIButton!

  let recipeViewModel = RecipeCollectionViewModel()

  
  let cuisineViewModel = CuisineCollectionViewModel()
  let profileModel = ProfileViewModel()
  let cuisines = Cuisines().getCuisines()
  
  let apiClient = SearchRecipesClient()
  var recipes: [RecipeElement] = []
  var quickRecipes: [RecipeElement] = []
  var veganRecipes: [RecipeElement] = []
  var vegetarianRecipes: [RecipeElement] = []
  var saladRecipes: [RecipeElement] = []
  var stirFryRecipes: [RecipeElement] = []
  var dessertRecipes: [RecipeElement] = []

  
  var inProgressTask: Cancellable?
  var quickRecipesCallTask: Cancellable?
  var veganRecipesCallTask: Cancellable?
  var vegetarianRecipesCallTask: Cancellable?
  var saladRecipesCallTask: Cancellable?
  var stirFryRecipesCallTask: Cancellable?
  var dessertRecipesCallTask: Cancellable?

  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.searchBar.delegate = self
    configureCollectionView()
    refreshSuggestedContent()
    refreshQuickRecipesContent()
    refreshVeganRecipesContent()
    refreshVegetarianRecipesContent()
    refreshSaladRecipesContent()
    refreshStirFryContent()
    refreshDessertContent()

  }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        print("why")
        performSegue(withIdentifier: "showAllSuggestedRecipes", sender: self)
    }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  

}

// MARK: UI Configuration
extension DiscoverViewController {

  func configureCollectionView() {
    let suggestedCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    suggestedCollectionView?.register(suggestedCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    let quickCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    quickCollectionView?.register(quickCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    let veganCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    veganCollectionView?.register(veganCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    let vegetarianCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    vegetarianCollectionView?.register(vegetarianCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    let saladsCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    saladsCollectionView?.register(saladsCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    let striFryCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    stirFryCollectionView?.register(striFryCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    let dessertCellNib = UINib(nibName: "RecipeCell", bundle: nil)
    dessertsCollectionView?.register(dessertCellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
    
    
    let cuisineCellNib = UINib(nibName: "CuisineCell", bundle: nil)
    cuisineCollectionView?.register(cuisineCellNib, forCellWithReuseIdentifier: CuisineCell.cellID)
  }

}

// MARK: UICollectionViewDelegateFlowLayout
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == cuisineCollectionView {
      return CGSize(width: view.bounds.width - (CuisineCell.cellPadding * 2), height: CuisineCell.cellHeight)
    } else {
      return CGSize(width: view.bounds.width - (RecipeCell.cellPadding * 2), height: RecipeCell.cellHeight)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView == cuisineCollectionView {
       return UIEdgeInsets(top: CuisineCell.cellPadding, left: CuisineCell.cellPadding, bottom: CuisineCell.cellPadding, right: CuisineCell.cellPadding)
    } else {
       return UIEdgeInsets(top: RecipeCell.cellPadding, left: RecipeCell.cellPadding, bottom: RecipeCell.cellPadding, right: RecipeCell.cellPadding)
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == cuisineCollectionView {
      return CuisineCell.cellPadding
    } else {
      return RecipeCell.cellPadding
    }
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }



}



// MARK: UICollectionViewDataSource and Delegate
extension DiscoverViewController {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    if collectionView == suggestedCollectionView {
      return recipes.count
    }
    if collectionView == cuisineCollectionView {
      return cuisines.count
    }
    if collectionView == quickCollectionView {
      return quickRecipes.count
    }
    if collectionView == veganCollectionView {
      return veganRecipes.count
    }
    if collectionView == vegetarianCollectionView {
      return vegetarianRecipes.count
    }
    if collectionView == vegetarianCollectionView {
      return vegetarianRecipes.count
    }
    if collectionView == saladsCollectionView {
      return saladRecipes.count
    }
    if collectionView == stirFryCollectionView {
      return stirFryRecipes.count
    }
    if collectionView == dessertsCollectionView {
      return dessertRecipes.count
    }
    
    
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == suggestedCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
        cell.recipe = recipes[indexPath.row]
        return cell
      } else {
        fatalError("Missing cell for indexPath: \(indexPath)")
      }
    }
    
    if collectionView == quickCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
        cell.recipe = quickRecipes[indexPath.row]
        return cell
      } else {
        fatalError("Missing cell for indexPath: \(indexPath)")
      }
    }
    
    if collectionView == veganCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
        cell.recipe = veganRecipes[indexPath.row]
        return cell
      } else {
        fatalError("Missing cell for indexPath: \(indexPath)")
      }
    }
    
    if collectionView == vegetarianCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
        cell.recipe = vegetarianRecipes[indexPath.row]
        return cell
      } else {
        fatalError("Missing cell for indexPath: \(indexPath)")
      }
    }
    
    if collectionView == saladsCollectionView {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
          cell.recipe = saladRecipes[indexPath.row]
          return cell
        } else {
          fatalError("Missing cell for indexPath: \(indexPath)")
        }
    }
    
    if collectionView == stirFryCollectionView {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
          cell.recipe = stirFryRecipes[indexPath.row]
          return cell
        } else {
          fatalError("Missing cell for indexPath: \(indexPath)")
        }
    }
    
    if collectionView == cuisineCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CuisineCell.cellID, for: indexPath) as? CuisineCell {
        cell.cuisine = cuisines[indexPath.row]
        return cell
      } else {
        fatalError("Missing cell for indexPath: \(indexPath)")
      }
    }
    
    if collectionView == dessertsCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
        cell.recipe = dessertRecipes[indexPath.row]
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
      detailVC.viewModel = recipeViewModel.detailViewModelForRowAtIndexPath(recipe)
    }
    
//    if let detailVC = segue.destination as? RecipesViewController,
//      let cuisine = sender as? Cuisine {
//      detailVC.viewModel = recipeViewModel.detailViewModelForRowAtIndexPath(recipe)
//    }
//
    if segue.identifier == "showRecipesWithCuisines" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
//        showRecipes.preferences = profileModel.getCuisinePreferences()
        showRecipes.pageTitle = "Cuisines"
    }
    
    if segue.identifier == "showAllSuggestedRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = profileModel.getCuisinePreferences()
        showRecipes.pageTitle = "Suggested Recipes"
    }
    
    if segue.identifier == "showAllQuickRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = ""
        showRecipes.pageTitle = "Quick & Easy Recipes"
    }
    if segue.identifier == "showAllVeganRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = "vegan"
        showRecipes.pageTitle = "Vegan Recipes"
    }
    if segue.identifier == "showAllVegetarianRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = "vegetarian"
        showRecipes.pageTitle = "Vegetarian Recipes"
    }
    if segue.identifier == "showAllSaladRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = "salad"
        showRecipes.pageTitle = "Salad Recipes"
    }
    if segue.identifier == "showAllStirFryRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = "stirfry"
        showRecipes.pageTitle = "Stir-Fry Recipes"
    }
    if segue.identifier == "showAllDessertRecipes" {
        let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
        showRecipes.preferences = "dessert"
        showRecipes.pageTitle = "Dessert Recipes"
    }

  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == suggestedCollectionView {
      let recipe = recipes[indexPath.row]
      performSegue(withIdentifier: "toDetailVC", sender: recipe)
    }
    if collectionView == cuisineCollectionView {
      let cuisine = cuisines[indexPath.row]
      performSegue(withIdentifier: "showRecipesWithCuisine", sender: cuisine)
    }
  }

}

// MARK: Data
extension DiscoverViewController {

  func refreshSuggestedContent() {
    guard inProgressTask == nil else {
      inProgressTask?.cancel()
      inProgressTask = nil
      return
    }
    let preferences = profileModel.getCuisinePreferences()
    inProgressTask = apiClient.fetchSuggestedRecipes(number: 10, cuisines: [preferences]) { [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
        self?.recipes = recipes
        self?.suggestedCollectionView?.reloadData()

      }
      else {
        return
      }
    } as? Cancellable
    
    
  }
  
  func refreshQuickRecipesContent() {
    guard quickRecipesCallTask == nil else {
      quickRecipesCallTask?.cancel()
      quickRecipesCallTask = nil
      return
    }
    quickRecipesCallTask = apiClient.fetchQuickRecipes(number: 10) { [weak self] (recipes) in
      self?.quickRecipesCallTask = nil
      if let recipes = recipes {
        self?.quickRecipes = recipes
        self?.quickCollectionView?.reloadData()

      }
      else {
        return
      }
    } as? Cancellable
  }

  func refreshVeganRecipesContent() {
    guard veganRecipesCallTask == nil else {
      veganRecipesCallTask?.cancel()
      veganRecipesCallTask = nil
      return
    }
    let preferences = "vegan"
    veganRecipesCallTask = apiClient.fetchSuggestedRecipes(number: 10, query: [preferences]) { [weak self] (recipes) in
      self?.veganRecipesCallTask = nil
      if let recipes = recipes {
        self?.veganRecipes = recipes
        self?.veganCollectionView?.reloadData()

      }
      else {
        return
      }
    } as? Cancellable
  }
  
  func refreshVegetarianRecipesContent() {
    guard vegetarianRecipesCallTask == nil else {
      vegetarianRecipesCallTask?.cancel()
      vegetarianRecipesCallTask = nil
      return
    }
    let preferences = "vegetarian"
    vegetarianRecipesCallTask = apiClient.fetchSuggestedRecipes(number: 10, query: [preferences]) { [weak self] (recipes) in
      self?.vegetarianRecipesCallTask = nil
      if let recipes = recipes {
        self?.vegetarianRecipes = recipes
        self?.vegetarianCollectionView?.reloadData()
      }
      else {
        return
      }
    } as? Cancellable
  }

  func refreshSaladRecipesContent() {
    guard saladRecipesCallTask == nil else {
      saladRecipesCallTask?.cancel()
      saladRecipesCallTask = nil
      return
    }
    let preferences = "salad"
    saladRecipesCallTask = apiClient.fetchSuggestedRecipes(number: 10, query: [preferences]) { [weak self] (recipes) in
      self?.saladRecipesCallTask = nil
      if let recipes = recipes {
        self?.saladRecipes = recipes
        self?.saladsCollectionView?.reloadData()
      }
      else {
        return
      }
    } as? Cancellable
  }
  
  
  func refreshStirFryContent() {
    guard stirFryRecipesCallTask == nil else {
      stirFryRecipesCallTask?.cancel()
      stirFryRecipesCallTask = nil
      return
    }
    let preferences = "stirfry"
    stirFryRecipesCallTask = apiClient.fetchSuggestedRecipes(number: 10,query: [preferences]) { [weak self] (recipes) in
      self?.stirFryRecipesCallTask = nil
      if let recipes = recipes {
        self?.stirFryRecipes = recipes
        self?.stirFryCollectionView?.reloadData()
      }
      else {
        return
      }
    } as? Cancellable
  }

  func refreshDessertContent() {
    guard dessertRecipesCallTask == nil else {
      dessertRecipesCallTask?.cancel()
      dessertRecipesCallTask = nil
      return
    }
    let preferences = "dessert"
    dessertRecipesCallTask = apiClient.fetchSuggestedRecipes(number: 10, query: [preferences]) { [weak self] (recipes) in
      self?.dessertRecipesCallTask = nil
      if let recipes = recipes {
        self?.dessertRecipes = recipes
        self?.dessertsCollectionView?.reloadData()
      }
      else {
        return
      }
    } as? Cancellable
  }
  
  func showError() {

  }

}
