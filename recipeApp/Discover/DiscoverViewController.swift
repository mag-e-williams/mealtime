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
  @IBOutlet var collectionView: UICollectionView!

  let viewModel = CollectionViewModel()
  let apiClient = SearchRecipesClient()
  var recipes: [RecipeElement] = []
  var inProgressTask: Cancellable?
  


  override func viewDidLoad() {
    super.viewDidLoad()
    
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
    let cellNib = UINib(nibName: "SuggestedCell", bundle: nil)
    collectionView?.register(cellNib, forCellWithReuseIdentifier: SuggestedCell.cellID)
//    self.collectionView.backgroundColor = [UIColor, white]
  }

}

// MARK: UICollectionViewDelegateFlowLayout
extension DiscoverViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width - (SuggestedCell.cellPadding * 2), height: SuggestedCell.cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: SuggestedCell.cellPadding, left: SuggestedCell.cellPadding, bottom: SuggestedCell.cellPadding, right: SuggestedCell.cellPadding)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return SuggestedCell.cellPadding
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
    return recipes.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SuggestedCell.cellID, for: indexPath) as? SuggestedCell {
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
        self?.collectionView?.reloadData()
      } else {
        return
      }
      } as? Cancellable
  }

  func showError() {

  }

}
