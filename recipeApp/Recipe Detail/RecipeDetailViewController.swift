//
//  RecipeDetailViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
  
  var recipeDetail: RecipeDetail?
  
  @IBOutlet var recipeLabel: UILabel!
  
  var viewModel: RecipeDetailViewModel?
  var recipeID: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let viewModel = viewModel {
      viewModel.refresh {
      }
    }
  }
}
