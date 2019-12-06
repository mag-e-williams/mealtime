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
 
  @IBAction func closeButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func doneButton(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  let filters = Filters().getFilters()
  let viewModel = FilterViewModel()
  
  var selectedFilters = [Filters]()

  override func viewDidLoad() {
    super.viewDidLoad()
    filterTable?.allowsMultipleSelection = true
    let bundle = Bundle(for: type(of: self))
    let cellNib = UINib(nibName: "TableViewCell", bundle: bundle)
    self.filterTable.register(cellNib, forCellReuseIdentifier: "cell")
    
    viewModel.refresh()
    self.filterTable.reloadData()
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return (viewModel.numberOfRows()!)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
    cell.title?.text = viewModel.titleForRowAtIndexPath(indexPath)
    return cell
  }
  
  
}
