//
//  RecipesViewController.swift
//  recipeApp
//
//  Created by Kasdan on 11/4/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class RecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  let viewModel = RecipesViewModel()
  
  @IBOutlet var tableView: UITableView!
  
  var recipes: [RecipeElement]?
  var query: String?
  
  @IBOutlet var searchBar:UISearchBar!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.searchBar.text = self.query!
    
    let bundle = Bundle(for: type(of: self))
    let cellNib = UINib(nibName: "TableViewCell", bundle: bundle)
    self.tableView.register(cellNib, forCellReuseIdentifier: "cell")
    
    viewModel.refresh(queryString: self.query!) { [unowned self] in
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    if let selectedRow = tableView.indexPathForSelectedRow {
      tableView.deselectRow(at: selectedRow, animated: true)
    }
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.numberOfRows()!
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.title?.text = viewModel.titleForRowAtIndexPath(indexPath)
    return cell
  }

  
//  @IBAction func createQuery(sender: UIButton){
//      let cleanQuery = (ingredientInput.text!).replacingOccurrences(of: " ", with: "")
//      let interpString = (cleanQuery).replacingOccurrences(of: ",", with: ",+")
//      let url = "https://api.spoonacular.com/recipes/findByIngredients?ingredients=\(interpString)&apiKey=0ff5861766ea48b0a55b2008c47bd778"
//
//      print(url)
//      print("bro")
//      let recipes = queryAPI(url)
//      print("pls dude")
//      print(recipes.count)
//  }


  
  
}
