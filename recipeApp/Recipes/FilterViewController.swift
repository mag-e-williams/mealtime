//
//  FilterViewController.swift
//  recipeApp
//
//  Created by Maggie Williams on 12/6/19.
//  Copyright © 2019 CMU. All rights reserved.
//
import UIKit
import Foundation

class FilterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet var filterTable: UITableView!
  let filters = Filters().getFilters()
  
  let viewModel = FilterViewModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let bundle = Bundle(for: type(of: self))
    print("HEREmotherfucker")
//    print(filters)
    let cellNib = UINib(nibName: "TableViewCell", bundle: bundle)
    self.filterTable.register(cellNib, forCellReuseIdentifier: "cell")
    
    self.filterTable.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    print("in tableView number rows")
    print(viewModel.numberOfRows())
    return (viewModel.numberOfRows()!)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    print("in tableView cellForRow")
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.title?.text = viewModel.titleForRowAtIndexPath(indexPath)
    print(viewModel.titleForRowAtIndexPath(indexPath))
    return cell
  }
  
  
  
}
