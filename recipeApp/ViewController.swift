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
        // Do any additional setup after loading the view.
    }
    
    @IBAction func createQuery(sender: UIButton){
        let queryArray = (ingredientInput.text!).split(separator: ",")
        let interpString = queryArray.joined(separator: ",+")
        let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(interpString)&apiKey=0ff5861766ea48b0a55b2008c47bd778"
        
        print(url)
    }


}

