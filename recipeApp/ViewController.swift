//
//  ViewController.swift
//  recipeApp
//
//  Created by Kasdan on 10/31/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  @IBOutlet weak var ingredientInput: UITextField!
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showRecipes" {
      let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
      showRecipes.query = self.ingredientInput.text
    }
  }


}

