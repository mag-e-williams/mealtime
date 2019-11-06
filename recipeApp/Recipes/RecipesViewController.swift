//
//  RecipesViewController.swift
//  recipeApp
//
//  Created by Kasdan on 11/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController {

  var recipes: [RecipeElement]?
  var query: String?
  
  @IBOutlet var searchBar:UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.searchBar.text = self.query
  }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
