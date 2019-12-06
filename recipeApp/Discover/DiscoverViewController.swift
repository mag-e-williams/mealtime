//
//  DiscoverViewController.swift
//  recipeApp
//
//  Created by Maggie on 12/5/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit



class DiscoverViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var suggestedCollectionView: UICollectionView!
  @IBOutlet var cuisineCollectionView: UICollectionView!

  @IBOutlet var seeAllSuggestedButton: UIButton!

  let recipeViewModel = RecipeCollectionViewModel()
  let cuisineViewModel = CuisineCollectionViewModel()
  let cuisines = Cuisines().getCuisines()
  
  let apiClient = SearchRecipesClient()
  var recipes: [RecipeElement] = []

  var inProgressTask: Cancellable?

  override func viewDidLoad() {
    super.viewDidLoad()
    
    seeAllSuggestedButton.semanticContentAttribute = UIApplication.shared
      .userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft
    
    configureCollectionView()
    refreshContent()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  

}

// MARK: UI Configuration
extension DiscoverViewController {

  func configureCollectionView() {
    let suggestedCellNib = UINib(nibName: "SuggestedCell", bundle: nil)
    suggestedCollectionView?.register(suggestedCellNib, forCellWithReuseIdentifier: SuggestedCell.cellID)
    
    let cuisineCellNib = UINib(nibName: "CuisineCell", bundle: nil)
    cuisineCollectionView?.register(cuisineCellNib, forCellWithReuseIdentifier: CuisineCell.cellID)
  }

}

// MARK: UICollectionViewDelegateFlowLayout
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    if collectionView == suggestedCollectionView {
      return CGSize(width: view.bounds.width - (SuggestedCell.cellPadding * 2), height: SuggestedCell.cellHeight)
    }
    if collectionView == cuisineCollectionView {
      return CGSize(width: view.bounds.width - (CuisineCell.cellPadding * 2), height: CuisineCell.cellHeight)
    }
    return CGSize()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView == suggestedCollectionView {
      return UIEdgeInsets(top: SuggestedCell.cellPadding, left: SuggestedCell.cellPadding, bottom: SuggestedCell.cellPadding, right: SuggestedCell.cellPadding)
    }
    if collectionView == cuisineCollectionView {
       return UIEdgeInsets(top: CuisineCell.cellPadding, left: CuisineCell.cellPadding, bottom: CuisineCell.cellPadding, right: CuisineCell.cellPadding)
    }
    return UIEdgeInsets()
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView == suggestedCollectionView {
      return SuggestedCell.cellPadding
    }
    if collectionView == cuisineCollectionView {
      return CuisineCell.cellPadding
    }
    return 0.0
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
    return 0
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if collectionView == suggestedCollectionView {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedCell.cellID, for: indexPath) as? SuggestedCell {
        cell.recipe = recipes[indexPath.row]
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
    
    return UICollectionViewCell()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RecipeDetailViewController,
      let recipe = sender as? RecipeElement {
      detailVC.viewModel = recipeViewModel.detailViewModelForRowAtIndexPath(recipe)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if collectionView == suggestedCollectionView {
      let recipe = recipes[indexPath.row]
      performSegue(withIdentifier: "toDetailVC", sender: recipe)
    }
  }
  


}

// MARK: Data
extension DiscoverViewController {

  func refreshContent() {
    guard inProgressTask == nil else {
      inProgressTask?.cancel()
      inProgressTask = nil
      return
    }

    inProgressTask = apiClient.fetchRecipes(inputString: "sugar") { [weak self] (recipes) in
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

  func showError() {

  }

}
