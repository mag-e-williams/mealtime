//
//  RecipeDetailViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 11/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
  
  var recipeDetail: RecipeDetail?
  
  @IBOutlet var recipeLabel: UILabel!
  @IBOutlet weak var recipeImg: UIImageView!
  @IBOutlet var ingredientsTable: UITableView!

  var viewModel: RecipeDetailViewModel?
  var recipeID: Int?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    if let viewModel = viewModel {
      viewModel.refresh {
        self.recipeDetail = viewModel.recipeDetail
        self.loadDetails()
      }
    }
    loadDetails()
  }
    
  
  func loadDetails(){
    self.recipeLabel.text = self.recipeDetail?.title
    let imageURL = URL(string: self.recipeDetail!.image)
    self.recipeImg.downloadImage(from: imageURL!)
  }
  
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
