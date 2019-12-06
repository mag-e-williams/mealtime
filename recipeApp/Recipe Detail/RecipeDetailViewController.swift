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
    
    var recipeDetail: RecipeDetail?
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var savedButton: UIButton!
    
    @IBOutlet weak var tableHeight: NSLayoutConstraint!

    
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet weak var recipeImg: UIImageView!
    
    @IBOutlet var ingredientsTable: UITableView!
    @IBOutlet var instructionsTable: UITableView!
    
    
    var viewModel: RecipeDetailViewModel?
    var recipeID: Int?
    
    override func viewDidLoad() {
      super.viewDidLoad()
      
      let bundle = Bundle(for: type(of: self))
      
      let ingredientsCellNib = UINib(nibName: "IngredientsTableCell", bundle: bundle)
      self.ingredientsTable.register(ingredientsCellNib, forCellReuseIdentifier: "cell")
      
      let instructionsCellNib = UINib(nibName: "InstructionsTableCell", bundle: bundle)
      self.instructionsTable.register(instructionsCellNib, forCellReuseIdentifier: "cell")

      if let viewModel = viewModel {
        viewModel.refresh {
          self.recipeDetail = viewModel.recipeDetail
          self.loadDetails()
          self.tableHeight.constant = self.ingredientsTable.contentSize.height
//          print("FUCCCCCCCKKKKKKKKKKKKKKKKKKSKSKKDJFALVBLRYTCOI34YBPVWT")
//          print(self.tableHeight.constant)
//          print(self.ingredientsTable.contentSize.height)

        }

      }
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
        print("self.recipeDetail is as follows: ")
        print("---------------------------------")
        print(self.recipeDetail!)
        print("---------------------------------")
        
//        let user = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
//        user.returnsObjectsAsFaults = false
//        do {
//            let result = try context.fetch(user)
//            for data in result as! [NSManagedObject] {
//                self.loadUser(data: data)
//                print(data.value(forKey: "first_name") as! String)
//            }
//        } catch {
//            print("Failed")
//        }
        
        
        saveRecipe(recipe: self.recipeDetail!)
    }
    
    //SAVING RECIPE TO COREDATA
    func saveRecipe(recipe: RecipeDetail){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "Recipe", in: context) {
            
            let newRecipe = NSManagedObject(entity: entity, insertInto: context)
            if let id = recipe.id {
                print(id)
                newRecipe.setValue(id, forKey: "id")
            }
            if let name = recipe.title {
                print(name)
                newRecipe.setValue(name, forKey: "name")
            }
            if let image = recipe.image {
                print(image)
                newRecipe.setValue(image, forKey: "image")
            }
            if let instructions = recipe.instructions {
                newRecipe.setValue(instructions, forKey: "instructions")
            }
            if let ingredients = recipe.extendedIngredients {
                newRecipe.setValue(ingredients, forKey: "ingredients")
            }
            if let price = recipe.pricePerServing {
                newRecipe.setValue(price, forKey: "price")
            }
            if let cheap = recipe.cheap {
                newRecipe.setValue(cheap, forKey: "cheap")
            }
            if let dairyFree = recipe.dairyFree {
                newRecipe.setValue(dairyFree, forKey: "dairy_free")
            }
            if let gluttenFree = recipe.glutenFree {
                newRecipe.setValue(gluttenFree, forKey: "gluten_free")
            }
            if let keto = recipe.ketogenic {
                newRecipe.setValue(keto, forKey: "keto")
            }
            if let vegan = recipe.vegan {
                newRecipe.setValue(vegan, forKey: "vegan")
            }
            if let vegetarian = recipe.vegetarian {
                newRecipe.setValue(vegetarian, forKey: "vegetarian")
            }
            if let servings = recipe.servings {
                newRecipe.setValue(servings, forKey: "servings")
            }
            if let readyInMinutes = recipe.readyInMinutes {
                newRecipe.setValue(readyInMinutes, forKey: "ready_in_minutes")
            }
            print("bottom of if lets")
        }
        do {
            print("before save")
            try context.save()
            print("after save")
        } catch {
            print("Failed saving")
        }
        //TODO: NEED TO ADD CODE TO ADD THIS RECIPE TO THE USERS LIST OF SAVED RECIPES 
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
