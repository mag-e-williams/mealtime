//
//  HomeViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/7/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITextFieldDelegate {
  
  @IBOutlet weak var ingredientInput: UITextField!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.ingredientInput.delegate = self
    self.ingredientInput.text = "sugar"
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showRecipes" {
      let showRecipes:RecipesViewController = segue.destination as! RecipesViewController
      showRecipes.query = self.ingredientInput.text
    }
  }
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    print("lol")
    ingredientInput.resignFirstResponder()
    return true
  }
  
}
