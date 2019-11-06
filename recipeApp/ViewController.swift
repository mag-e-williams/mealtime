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
  
//    @IBAction func createQuery(sender: UIButton){
//        let cleanQuery = (ingredientInput.text!).replacingOccurrences(of: " ", with: "")
//        let interpString = (cleanQuery).replacingOccurrences(of: ",", with: ",+")
//        let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(interpString)&apiKey=0ff5861766ea48b0a55b2008c47bd778"
//
//        print(url)
//        print("bro")
//        let recipes = queryAPI(url)
//        print("pls dude")
//        print(recipes.count)
//    }
//


}

