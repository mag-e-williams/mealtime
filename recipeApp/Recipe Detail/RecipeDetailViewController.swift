//
//  RecipeDetailViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    var recipeDetail: RecipeDetail?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var savedButton: UIButton!
    
//    @IBOutlet weak var tableHeight: NSLayoutConstraint!
//    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var prepTime: UILabel!
  
    @IBOutlet weak var recipeImg: UIImageView!
    
    @IBOutlet var ingredientsTable: UITableView!
    @IBOutlet var instructionsTable: UITableView!

  
    var viewModel: RecipeDetailViewModel?
    var recipeID: Int?
//    var tabItems: [UITabBarItem]
  
    var recipeDetail: RecipeDetail? {
      didSet {
        guard let recipeDetail = recipeDetail else {
          return
        }
        
       
          let ratingString : String
          let prepTimeString : String
//          if recipeDetail.calories == nil {
//              ratingString = "N/A"
//          }
//          else {
//              ratingString = "\(recipeDetail.calories!) cal"
//          }
          
          if recipeDetail.readyInMinutes == nil {
              prepTimeString = "N/A"
          }
          else {
              prepTimeString = "\(recipeDetail.readyInMinutes!) min"
          }
        prepTime.text = prepTimeString
//        rating.text = ratingString
      }
    }
    
  
    override func viewDidLoad() {
      super.viewDidLoad()
//        viewModel?.resetData()
      
      let bundle = Bundle(for: type(of: self))
      
      let ingredientsCellNib = UINib(nibName: "IngredientsTableCell", bundle: bundle)
      self.ingredientsTable.register(ingredientsCellNib, forCellReuseIdentifier: "cell")
      
      let instructionsCellNib = UINib(nibName: "InstructionsTableCell", bundle: bundle)
      self.instructionsTable.register(instructionsCellNib, forCellReuseIdentifier: "cell")

      
      if let viewModel = viewModel {
        viewModel.refresh {
          self.recipeDetail = viewModel.recipeDetail
          self.loadDetails()

        }

      }
      

//      tabItems = tabBar.items!
      

      
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
  
    //  loading all the data into the screen
    
    func loadDetails(){
        
        let imageURL: URL
        if let title = self.recipeDetail?.title {
            self.recipeLabel.text = title
        } else {
            self.recipeLabel.text = "No title given"
        }
        
        if let image = self.recipeDetail!.image {
            imageURL = URL(string: image)!
        } else {
            imageURL = URL(string: "https://upload.wikimedia.org/wikipedia/commons/7/75/No_image_available.png")!
        }
        self.recipeImg.downloadImage(from: imageURL)
        
        ingredientsTable.reloadData()
        instructionsTable.reloadData()
        
 
    }
  

    
    //  Ingredients + Instructions table views
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTable {
            return (viewModel?.numberOfIngredientsTableRows()!)!
        } else if tableView == instructionsTable {
            return (viewModel?.numberOfInstructionTableRows()!)!
        }
        return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ingredientsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientsTableCell
            cell.title?.text = viewModel?.ingredientTitleForRowAtIndexPath(indexPath)
            cell.ingredientAmount?.text = viewModel?.ingredientAmountForRowAtIndexPath(indexPath)
            return cell
        } else if tableView == instructionsTable {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! InstructionsTableCell
            cell.title?.text = viewModel?.instructionForRowAtIndexPath(indexPath)
            cell.stepNumber?.text = viewModel?.instructionNumberForRowAtIndexPath(indexPath)
            return cell
        }
        return UITableViewCell()
    }
    
    
    
    
    
    //   Image Loading Functions
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.recipeImg.image = UIImage(data: data)
            }
        }
    }
    
    
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let recipe = self.recipeDetail!
        let newRecipe = viewModel!.createRecipe("Recipe")
        
        newRecipe?.setValue(recipe.id!, forKey: "id")
        newRecipe?.setValue(recipe.title!, forKey: "name")
        newRecipe?.setValue(recipe.image!, forKey: "image")
        newRecipe?.setValue(recipe.servings!, forKey: "servings")
        newRecipe?.setValue(recipe.readyInMinutes!, forKey: "ready_in_minutes")
        newRecipe?.setValue(recipe.cheap!, forKey: "cheap")
        newRecipe?.setValue(recipe.instructions!, forKey: "instructions")
        
        print("new recipe")
        print(newRecipe!)
        do {
            try context.save()
            print("context was saved")
        } catch {
            print("Failed saving")
        }
//        let fetchedRecipe = viewModel?.fetchRecipe("Recipe")
//        print("all fetched recipes")
//        print(fetchedRecipe)
    }
}

extension UIImageView {
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    func downloadImage(from url: URL) {
        getData(from: url) {
            data, response, error in
            guard let data = data, error == nil else {
                return
            }
            DispatchQueue.main.async() {
                self.image = UIImage(data: data)
            }
        }
    }
}
