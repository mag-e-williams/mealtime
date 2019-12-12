//
//  RecipesViewController.swift
//  recipeApp
//
//  Created by Kasdan on 11/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit



class RecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
  
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var collectionView: UICollectionView!
//  @IBOutlet var numResults: UILabel!

  @IBOutlet var pageTitleLabel: UILabel!
  @IBOutlet var pageSubtitleLabel: UILabel!

  
  @IBAction func close() {
      performSegueToReturnBack()
  }
  
  var viewModel = RecipesViewModel()
  let filterViewModel = FilterViewModel()
  let apiClient = SearchRecipesClient()
  var recipes: [RecipeElement] = []
  var inProgressTask: Cancellable?
  
  var query: String?
  var preferences: String?

  var pageTitle: String?
  var pageSubtitle: String?

  var filters: [Filter]?

  var queryFilters: [Filter]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    searchBar.delegate = self
    if self.query == nil {
      self.searchBar.text = " "
    } else {
      self.searchBar.text = self.query!
    }
    
    if (!viewModel.title.isEmpty) {
      self.pageTitleLabel.text = viewModel.title
    } else {
//      self.pageTitleLabel.text = "Recipes"
      print(self.pageTitle)
      if self.pageTitle == nil || self.pageTitle!.isEmpty {
         self.pageTitleLabel.text = "Recipes"
       } else {
         self.pageTitleLabel.text = self.pageTitle
       }
    }
   
    
//     self.pageSubtitle == nil {
//      self.pageSubtitleLabel.text = "Recipes"
//    } else {
//      self.pageSubtitleLabel.text = self.pageSubtitle
//    }
//
    
    
    if self.filters == nil {
      self.filters = []
    } else {
      self.queryFilters = self.filters
    }
    
    configureCollectionView()
    refreshContent()
    pageSubtitleLabel.text = "showing \(recipes.count) recipes"

//    if (self.query != "" && self.query != nil) {
//      numResults.text = "\(recipes.count) results for \"\(self.query ?? "")\""
//    } else {
//      numResults.text = "\(recipes.count) results"
//    }
    
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  

  
}
//
// MARK: UI Configuration
extension RecipesViewController {

  func configureCollectionView() {
    let cellNib = UINib(nibName: "RecipeCell", bundle: nil)
    collectionView?.register(cellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
//    collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
  }

}

// MARK: UICollectionViewDelegateFlowLayout
extension RecipesViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width - (RecipeCell.cellPadding * 2), height: RecipeCell.cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: RecipeCell.cellPadding, left: RecipeCell.cellPadding, bottom: RecipeCell.cellPadding, right: RecipeCell.cellPadding)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return RecipeCell.cellPadding
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }



}



// MARK: UICollectionViewDataSource and Delegate
extension RecipesViewController {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return recipes.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
      cell.recipe = recipes[indexPath.row]
      return cell
    } else {
      fatalError("Missing cell for indexPath: \(indexPath)")
    }
  }
  


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RecipeDetailViewController,
      let recipe = sender as? RecipeElement {
      detailVC.viewModel = viewModel.detailViewModelForRowAtIndexPath(recipe)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let recipe = recipes[indexPath.row]
    
    performSegue(withIdentifier: "toDetailVC", sender: recipe)
  }
  


}

// MARK: Data
extension RecipesViewController {

  func refreshContent() {
    guard inProgressTask == nil else {
      inProgressTask?.cancel()
      inProgressTask = nil
      return
    }
    var input: String = ""
    if self.query != nil && self.query != "" {
      input = self.query!
    }
    if self.preferences != nil && self.preferences != "" {
      input = self.preferences!
    }
    if (self.pageTitle == "RecipeResults") {
      inProgressTask = apiClient.fetchSuggestedRecipes(query: [input]){ [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
        print("recipes")
        print(recipes)
        let filteredRecipes = self?.filterViewModel.filterOutCuisines(recipes)
        self?.recipes = filteredRecipes!
        print("filtered")
        print(self?.recipes)
        self?.collectionView?.reloadData()
      } else {
        return
      }
      } as? Cancellable
    }
    
    if (self.pageTitle == "Quick & Easy Recipes") {
      inProgressTask = apiClient.fetchQuickRecipes(){ [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
        print("recipes")
        print(recipes)
        let filteredRecipes = self?.filterViewModel.filterOutCuisines(recipes)
        self?.recipes = filteredRecipes!
        print("filtered")
        print(self?.recipes)
        self?.collectionView?.reloadData()
      } else {
        return
      }
      } as? Cancellable
    } else if (self.pageTitle == "Suggested Recipes") {
      inProgressTask = apiClient.fetchSuggestedRecipes(cuisines: [input]){ [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
        print("recipes")
        print(recipes)
        let filteredRecipes = self?.filterViewModel.filterOutCuisines(recipes)
        self?.recipes = filteredRecipes!
        print("filtered")
        print(self?.recipes)
        self?.collectionView?.reloadData()
      } else {
        return
      }
      } as? Cancellable
    }
    else {
    inProgressTask = apiClient.fetchSuggestedRecipes(query: [input]){ [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
        print("recipes")
        print(recipes)
        let filteredRecipes = self?.filterViewModel.filterOutCuisines(recipes)
        self?.recipes = filteredRecipes!
        print("filtered")
        print(self?.recipes)
        self?.collectionView?.reloadData()
      } else {
        return
      }
      } as? Cancellable
    }
  }

  func showError() {

  }

}
