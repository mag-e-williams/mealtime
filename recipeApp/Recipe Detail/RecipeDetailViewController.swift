//
//  RecipeDetailViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var recipeDetail: RecipeDetail?
  
  @IBOutlet var recipeLabel: UILabel!
  @IBOutlet weak var recipeImg: UIImageView!
  
  @IBOutlet var ingredientsTable: UITableView!
  @IBOutlet var instructionsTable: UITableView!


  var viewModel: RecipeDetailViewModel?
  var recipeID: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundle = Bundle(for: type(of: self))
    let cellNib = UINib(nibName: "IngredientsTableCell", bundle: bundle)
    self.ingredientsTable.register(cellNib, forCellReuseIdentifier: "cell")
  
    if let viewModel = viewModel {
      viewModel.refresh {
        self.recipeDetail = viewModel.recipeDetail
        self.loadDetails()
      }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
   
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
    
    self.ingredientsTable.reloadData()
  }
  
  
//  Ingredients table view
  
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel?.numberOfIngredientsTableRows()!)!
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! IngredientsTableCell
    cell.title?.text = viewModel?.ingredientTitleForRowAtIndexPath(indexPath)
    return cell
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
