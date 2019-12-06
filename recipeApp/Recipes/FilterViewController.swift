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
    let userViewModel = ProfileViewModel()
    let user = userViewModel.fetchUser("User")
    user?.setValue(viewModel.selectedFilters, forKey: "filters")
    
    dismiss(animated: true, completion: nil)
  }
  
  var filters = Filters().getFilters()
  let viewModel = FilterViewModel()
  
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
    
    if filters[indexPath.row].isSelected! {
      if !cell.isSelected {
         tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
      }
    } else {
      if cell.isSelected {
        tableView.deselectRow(at: indexPath, animated: false)
      }
    }
    
    return cell
  }
 
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  
   // update ViewModel item
    viewModel.filters[indexPath.row].isSelected = true
    viewModel.didToggleSelection?(!viewModel.selectedFilters.isEmpty)
    print(viewModel.selectedFilters)
    
  }
     
   func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
         
         // update ViewModel item
    viewModel.filters[indexPath.row].isSelected = false
    viewModel.didToggleSelection?(!viewModel.selectedFilters.isEmpty)
    print(viewModel.selectedFilters)

  }
     
   func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
    if viewModel.selectedFilters.count > 2 {
         return nil
     }
      return indexPath
    }
  
}
