//
//  RecipeDetailViewController.swift
//  mealtime
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit
import CoreData

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var savedButton: UIButton!
    @IBOutlet weak var ingredientsTableButton: UIButton!
    @IBOutlet weak var instructionsTableButton: UIButton!
    @IBOutlet weak var similarRecipesButton: UIButton!

    @IBOutlet weak var pageContent: UIStackView!
    @IBOutlet weak var pageContentHeight: NSLayoutConstraint!

    
    @IBOutlet var recipeLabel: UILabel!
    @IBOutlet var prepTime: UILabel!
    @IBOutlet var rating: UILabel!
    @IBOutlet var servings: UILabel!
  
    @IBOutlet weak var recipeImg: UIImageView!
    
    @IBOutlet var ingredientsTable: UITableView!
    @IBOutlet var instructionsTable: UITableView!
    @IBOutlet var suggestedRecipesCollection: UICollectionView!
  
    @IBOutlet weak var ingredientsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var instructionsTableHeight: NSLayoutConstraint!
    @IBOutlet weak var suggestedRecipesCollectionHeight: NSLayoutConstraint!

    let apiClient = SearchRecipesClient()
    var dataViewModel = ProfileViewModel()

    let colorSchemeGreen = UIColor(red: 153, green: 204, blue: 51)
    let lightTextColor = UIColor(red: 164, green: 165, blue: 166)
    let backgroundColor = UIColor(red: 37, green: 38, blue: 41)

  
    var viewModel: RecipeDetailViewModel?
    let recipesViewModel = RecipesViewModel()

    var recipeID: Int?
    var savedRecipeIDs = Set<Int>()
    var similarRecipes: [RecipeElement] = []

    var inProgressTask: Cancellable?

    var recipeDetail: RecipeDetail? {
      didSet {
        guard let recipeDetail = recipeDetail else {
          return
        }
        
       
          let ratingString : String
          let prepTimeString : String
          let servingString: String
          if recipeDetail.healthScore == nil {
              ratingString = "N/A"
          }
          else {
              ratingString = "Health Score: \(recipeDetail.healthScore!)"
          }
          
          if recipeDetail.readyInMinutes == nil {
              prepTimeString = "N/A"
          }
          else {
              prepTimeString = "\(recipeDetail.readyInMinutes!) min"
          }
        if recipeDetail.servings == nil {
            servingString = "N/A"
        }
        else {
            if recipeDetail.servings! == 1 {
                servingString = "\(recipeDetail.servings!) Serving"
            }
            else {
                servingString = "\(recipeDetail.servings!) Servings"
            }
        }
        prepTime.text = prepTimeString
        rating.text = ratingString
        servings.text = servingString
      }
    }
    
  
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

        }

      }
      configureCollectionView()
      refreshContent()
      
      updateSavedButton((self.recipeDetail?.id)!)
      
      ingredientsTable.isHidden = false
      instructionsTable.isHidden = true
      suggestedRecipesCollection.isHidden = true
      
      ingredientsTableButton.addTopBorderWithColor(color: backgroundColor, width: 1)
      instructionsTableButton.addTopBorderWithColor(color: backgroundColor, width: 1)
      similarRecipesButton.addTopBorderWithColor(color: backgroundColor, width: 1)
      
      ingredientsTableButton.addBottomBorderWithColor(color: colorSchemeGreen, width: 3)
      instructionsTableButton.addBottomBorderWithColor(color: backgroundColor, width: 3)
      similarRecipesButton.addBottomBorderWithColor(color: backgroundColor, width: 3)

    }

  
    @IBAction func showIngredientsButtonPressed(_ sender: UIButton) {
      ingredientsTable.isHidden = false
      instructionsTable.isHidden = true
      suggestedRecipesCollection.isHidden = true
      
      ingredientsTableButton.addBottomBorderWithColor(color: colorSchemeGreen, width: 3)
      instructionsTableButton.addBottomBorderWithColor(color: backgroundColor, width: 3)
      similarRecipesButton.addBottomBorderWithColor(color: backgroundColor, width: 3)
    
      resizeScreen()
      

    }
  
    @IBAction func showInstructionsButtonPressed(_ sender: UIButton) {
      ingredientsTable.isHidden = true
      instructionsTable.isHidden = false
      suggestedRecipesCollection.isHidden = true

      ingredientsTableButton.addBottomBorderWithColor(color: backgroundColor, width: 3)
      instructionsTableButton.addBottomBorderWithColor(color: colorSchemeGreen, width: 3)
      similarRecipesButton.addBottomBorderWithColor(color: backgroundColor, width: 3)

      resizeScreen()
      
  }
    
    @IBAction func showSimilarRecipesButtonPressed(_ sender: UIButton) {
      ingredientsTable.isHidden = true
      instructionsTable.isHidden = true
      suggestedRecipesCollection.isHidden = false

      ingredientsTableButton.addBottomBorderWithColor(color: backgroundColor, width: 3)
      instructionsTableButton.addBottomBorderWithColor(color: backgroundColor, width: 3)
      similarRecipesButton.addBottomBorderWithColor(color: colorSchemeGreen, width: 3)

      resizeScreen()
    }
  
    func resizeScreen() {
      ingredientsTableHeight.constant = ingredientsTable.contentSize.height
      instructionsTableHeight.constant = instructionsTable.contentSize.height
      suggestedRecipesCollectionHeight.constant = suggestedRecipesCollection.contentSize.height
      
//      scrollView.contentSize.height = pageContentHeight.constant
    }
  
  
    func updateSavedButton(_ recipeID: Int) {
      if (self.savedRecipeIDs.contains(recipeID)) {
        savedButton.tintColor = colorSchemeGreen
        //      let image = UIImage(named: "heart.fill")
        savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
      }else if (!self.savedRecipeIDs.contains(recipeID)) {
        self.savedButton.tintColor = lightTextColor
        self.savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
      }
    }
  
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      updateSavedButton((self.recipeDetail?.id)!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
      updateSavedButton((self.recipeDetail?.id)!)
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
        
        self.savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()
             
        if let id = self.recipeDetail?.id {
           if (savedRecipeIDs.contains(id)) {
           self.savedButton.tintColor = colorSchemeGreen
           self.savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
          }
        }
      
        ingredientsTable.reloadData()
        instructionsTable.reloadData()
      
        self.savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()
        
        ingredientsTableHeight.constant = ingredientsTable.contentSize.height
        instructionsTableHeight.constant = instructionsTable.contentSize.height
        suggestedRecipesCollectionHeight.constant = suggestedRecipesCollection.contentSize.height
      
//        scrollView.contentSize.height = CGFloat(pageContentHeight.constant)
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
        self.savedRecipeIDs = dataViewModel.profileLoadSavedRecipes()
      

        if let id = self.recipeDetail?.id {
          if (!savedRecipeIDs.contains(id)) {
            
            self.savedButton.tintColor = colorSchemeGreen
            self.savedButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            
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
            
//            print(newRecipe!)
            do {
                try context.save()
                print("context was saved")
            } catch {
                print("Failed saving")
            }
          } else if (savedRecipeIDs.contains(id)) {
            self.savedButton.tintColor = lightTextColor
            self.savedButton.setImage(UIImage(systemName: "heart"), for: .normal)
            
            dataViewModel.deleteSingleRecipe(id)
          }
        }
      

    }
}

// MARK: UI Configuration
extension RecipeDetailViewController {

  func configureCollectionView() {
    let cellNib = UINib(nibName: "RecipeCell", bundle: nil)
    suggestedRecipesCollection?.register(cellNib, forCellWithReuseIdentifier: RecipeCell.cellID)
  }

}

// MARK: UICollectionViewDelegateFlowLayout
extension RecipeDetailViewController: UICollectionViewDelegateFlowLayout {

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.bounds.width - (RecipeCell.cellPadding * 2), height: RecipeCell.cellHeight)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: RecipeCell.cellPadding, left: RecipeCell.cellPadding, bottom: RecipeCell.cellPadding, right: RecipeCell.cellPadding)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return RecipeCell.cellPadding
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return 0.0
  }
}

// MARK: UICollectionViewDataSource and Delegate
extension RecipeDetailViewController {

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return similarRecipes.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCell.cellID, for: indexPath) as? RecipeCell {
      cell.recipe = similarRecipes[indexPath.row]
      return cell
    } else {
      fatalError("Missing cell for indexPath: \(indexPath)")
    }
  }
  


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let detailVC = segue.destination as? RecipeDetailViewController,
      let recipe = sender as? RecipeElement {
      detailVC.viewModel = recipesViewModel.detailViewModelForRowAtIndexPath(recipe)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let recipe = similarRecipes[indexPath.row]
    
    performSegue(withIdentifier: "toDetailVC", sender: recipe)
  }
}

// MARK: Data
extension RecipeDetailViewController {

  func refreshContent() {
    guard inProgressTask == nil else {
      inProgressTask?.cancel()
      inProgressTask = nil
      return
    }


  if let recipe = self.recipeDetail {

    inProgressTask = apiClient.fetchSimilarRecipes(inputID: recipe.id!) { [weak self] (recipes) in
      self?.inProgressTask = nil
      if let recipes = recipes {
//        print("recipes")
        print(recipes)
        self?.similarRecipes = recipes
//        print("CWE")
//        for x in recipes {
//            x.image = "https://spoonacular.com/recipeImages/" + x.image!
//        }
        self?.suggestedRecipesCollection?.reloadData()
      } else {
        return
      }
      } as? Cancellable
    }
  }

  func showError() {

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


extension UIButton {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0,y: 0, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width,y: 0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:self.frame.size.height - width, width:self.frame.size.width, height:width)
        self.layer.addSublayer(border)
    }

    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:0, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }

    func addMiddleBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x:self.frame.size.width/2, y:0, width:width, height:self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

