//
//  RecipesViewController.swift
//  recipeApp
//
//  Created by Kasdan on 11/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit



class RecipesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
  
  @IBOutlet var searchBar: UISearchBar!
  @IBOutlet var collectionView: UICollectionView!

  let viewModel = RecipesViewModel()
  let apiClient = SearchRecipesClient()
  var recipes: [RecipeElement] = []
  var inProgressTask: Cancellable?
  
  var query: String?


  override func viewDidLoad() {
    super.viewDidLoad()
    self.searchBar.text = self.query!
    
    configureCollectionView()
    refreshContent()
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
    collectionView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
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


    inProgressTask = apiClient.fetchRecipes(inputString: self.query!) { [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
        self?.recipes = recipes
        self?.collectionView?.reloadData()
      } else {
        return
      }
      } as? Cancellable
  }

  func showError() {

  }

}
